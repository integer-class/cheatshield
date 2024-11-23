# face_detector.py
import os
import cv2
import torch
from facenet_pytorch import MTCNN
import numpy as np
from PIL import Image
import multiprocessing

class FaceDetector:
    def __init__(self):
        # Initialize MTCNN
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        self.mtcnn = MTCNN(
            keep_all=True,
            device=self.device,
            select_largest=False,
            post_process=False,
            margin=20
        )

    async def process_frame(self, frame_path, faces_dir, processed_dir):
        """
        Process a single frame to detect faces
        
        Args:
            frame_path: Path to input frame
            faces_dir: Directory to save extracted faces
            processed_dir: Directory to save processed frames
        """
        # Read image with PIL
        image = Image.open(frame_path)
        
        # Convert PIL image to RGB if it's not
        if image.mode != 'RGB':
            image = image.convert('RGB')
        
        # Detect faces
        boxes, probs = self.mtcnn.detect(image)
        
        if boxes is None:
            # Save original frame to processed dir if no faces found
            processed_path = os.path.join(processed_dir, os.path.basename(frame_path))
            image.save(processed_path)
            return 0
        
        # Convert PIL image to OpenCV format for drawing
        opencv_image = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)
        
        # Process each detected face
        for i, (box, prob) in enumerate(zip(boxes, probs)):
            if prob < 0.9:  # Skip low confidence detections
                continue
                
            # Get coordinates
            x1, y1, x2, y2 = [int(coord) for coord in box]
            
            # Draw red rectangle
            cv2.rectangle(opencv_image, (x1, y1), (x2, y2), (0, 0, 255), 2)
            
            # Add confidence score text
            conf_text = f"{prob:.2f}"
            cv2.putText(opencv_image, conf_text, (x1, y1-10), 
                       cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255), 2)
            
            # Extract and save face region
            face_region = opencv_image[y1:y2, x1:x2]
            
            # Generate face filename
            base_name = os.path.splitext(os.path.basename(frame_path))[0]
            face_filename = f"{base_name}_face_{i}_conf_{prob:.2f}.png"
            face_path = os.path.join(faces_dir, face_filename)
            
            # Save face
            cv2.imwrite(face_path, face_region)
        
        # Save processed frame
        processed_path = os.path.join(processed_dir, os.path.basename(frame_path))
        cv2.imwrite(processed_path, opencv_image)
        
        return len([prob for prob in probs if prob > 0.9])

async def process_frame(detector, frames_dir, faces_dir, processed_dir, filename):
    frame_path = os.path.join(frames_dir, filename)
    faces_found = detector.process_frame(frame_path, faces_dir, processed_dir)
    total_faces += faces_found
    processed_frames += 1
    
    # Print progress
    print(f"Processed {filename}: {faces_found} faces detected")

async def detect_faces_in_frames(frames_dir, faces_dir, processed_dir):
    """
    Process all frames and detect faces
    
    Args:
        frames_dir: Input frames directory
        faces_dir: Output directory for face images
        processed_dir: Output directory for processed frames
    """
    # Create output directories
    os.makedirs(faces_dir, exist_ok=True)
    os.makedirs(processed_dir, exist_ok=True)
    
    detector = FaceDetector()
    total_faces = 0
    processed_frames = 0
    
    # Get list of image files
    image_files = [f for f in os.listdir(frames_dir) 
                  if f.lower().endswith(('.png', '.jpg', '.jpeg'))]
    
    # Process each frame
    for filename in image_files:
        with multiprocessing.Pool(processes=4) as pool:
            frame_path = os.path.join(frames_dir, filename)
            faces_found = detector.process_frame(frame_path, faces_dir, processed_dir)
            total_faces += faces_found
            processed_frames += 1
        
        # Print progress
        print(f"Processed {filename}: {faces_found} faces detected")
    
    return {
        "processed_frames": processed_frames,
        "total_faces": total_faces
    }