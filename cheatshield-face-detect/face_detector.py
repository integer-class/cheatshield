# face_detector.py
import asyncio
from concurrent.futures import ThreadPoolExecutor
import os
import traceback
import cv2
from fastapi import HTTPException
import torch
from facenet_pytorch import MTCNN
import numpy as np
from typing import cast, final
from PIL import Image
from torch._prims_common import DeviceLikeType

@final
class FaceDetector:
    device: DeviceLikeType
    mtcnn: MTCNN
    confidence_level = 0.95

    def __init__(self):
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        self.mtcnn = MTCNN(
            keep_all=True,
            device=self.device,
            select_largest=False,
            post_process=False,
            margin=20
        )

    def process_frame(self, frame_path: str, faces_dir: str, processed_dir: str):
        # Read image with PIL
        image = Image.open(frame_path)

        # Convert PIL image to RGB if it's not
        if image.mode != 'RGB':
            image = image.convert('RGB')

        boxes, probs, _extra = self.mtcnn.detect(image, landmarks=True)

        if boxes is None:
            # ignore images without faces
            return 0

        opencv_image = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)

        for i, (box, prob) in enumerate(zip(cast(list[tuple[float,float,float,float]], boxes), cast(list[float], probs))):
            # skip low confidence faces, the threshold here is 95%
            if prob < self.confidence_level:
                continue

            x1, y1, x2, y2 = [int(coord) for coord in box]

            _ = cv2.rectangle(
                img=opencv_image,
                pt1=(x1, y1),
                pt2=(x2, y2),
                color=(0, 0, 255),
                thickness=2
            )

            conf_text = f"{prob:.2f}"
            _ = cv2.putText(opencv_image, conf_text, (x1, y1-10),
                       cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255), 2)

            face_region = opencv_image[y1:y2, x1:x2]

            base_name = os.path.splitext(os.path.basename(frame_path))[0]
            face_filename = f"{base_name}_face_{i}_conf_{prob:.2f}.png"
            face_path = os.path.join(faces_dir, face_filename)

            # skip faces that are too small
            if face_region.size == 0:
                continue

            try:
                _ = cv2.imwrite(face_path, face_region)
            except Exception as e:
                print(f"Error writing face: {e} into {face_path}")

        processed_path = os.path.join(processed_dir, os.path.basename(frame_path))
        try:
            _ = cv2.imwrite(processed_path, opencv_image)
        except Exception as e:
            print(f"Error writing face: {e} into {processed_path}")

        return len([prob for prob in cast(list[float], probs) if prob > self.confidence_level])

def process_frame(detector: FaceDetector,
                  frames_dir: str,
                  faces_dir: str,
                  processed_dir: str,
                  filename: str) -> int:
    frame_path = os.path.join(frames_dir, filename)
    faces_found = detector.process_frame(frame_path, faces_dir, processed_dir)
    return faces_found

async def detect_faces_in_frames(frames_dir: str, faces_dir: str, processed_dir: str):
    os.makedirs(faces_dir, exist_ok=True)
    os.makedirs(processed_dir, exist_ok=True)

    detector = FaceDetector()
    total_faces = 0
    processed_frames = 0

    image_files = [f for f in os.listdir(frames_dir)
                  if f.lower().endswith(('.png', '.jpg', '.jpeg'))]

    with ThreadPoolExecutor() as executor:
        loop = asyncio.get_running_loop()
        tasks: list[asyncio.Future[int]] = []
        for filename in image_files:
            frame_path = os.path.join(frames_dir, filename)
            tasks.append(
                loop.run_in_executor(executor, detector.process_frame, frame_path, faces_dir, processed_dir)
            )
            processed_frames += 1
        gathered_results = await asyncio.gather(*tasks, return_exceptions=True)
        for result in gathered_results:
            if isinstance(result, BaseException):
                traceback.print_exc()
                raise HTTPException(status_code=500, detail=str(result))
            else:
                total_faces += result

    return {
        "processed_frames": processed_frames,
        "total_faces": total_faces
    }
