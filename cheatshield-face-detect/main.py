import os
import shutil
import traceback
import asyncio
from typing import Annotated, Any
from fastapi import FastAPI, File, Form, UploadFile, HTTPException
from frame_extractor import extract_frames
from face_detector import detect_faces_in_frames
from timer import PerformanceTimer
from face_embedding import FaceEmbedding
import torch

from util import prepare_workspace_dir_for_user, clean_up_workspace_dir_for_user

print("Face Detection API")
print("Is CUDA Available: ", torch.cuda.is_available())

app = FastAPI(debug=True)

@app.get("/")
async def root():
    return {"message": "Face Detection API"}

@app.get("/api/v1/healthz")
async def health():
    """
    Health check endpoint
    """
    return {"status": "ok"}

@app.post("/api/v1/face-recognition/embedding")
async def generate_embedding(
    user_id: Annotated[str, Form()],
    straight_video: Annotated[UploadFile, Form(...)],
    up_video: Annotated[UploadFile, Form(...)],
    down_video: Annotated[UploadFile, Form(...)],
    left_video: Annotated[UploadFile, Form(...)],
    right_video: Annotated[UploadFile, Form(...)]
) -> dict[str, Any]:
    """
    Generates embeddings for the faces in the uploaded videos
    """

    timer = PerformanceTimer()

    dirs = prepare_workspace_dir_for_user(user_id)

    # Clean up workspace once before processing
    clean_up_workspace_dir_for_user(dirs)

    video_with_directions = zip(
        ["straight", "up", "down", "left", "right"],
        [straight_video, up_video, down_video, left_video, right_video]
    )

    async def process_video(direction: str, video: UploadFile):
        print(f"Processing {direction} video...")
        loop = asyncio.get_event_loop()
        input_video_path = os.path.join(dirs["input_video_dir"], f"video-{direction}.mp4")
        await loop.run_in_executor(None, lambda: shutil.copyfileobj(video.file, open(input_video_path, "wb")))

        with timer.timer("extract_frames"):
            frame_paths = await extract_frames(input_video_path, dirs["frames_dir"])

        with timer.timer("detect_faces"):
            detect_results = await detect_faces_in_frames(
                frames_dir=dirs["frames_dir"],
                faces_dir=dirs["faces_dir"],
                processed_dir=dirs["processed_frames_dir"]
            )

        with timer.timer("generate_embeddings"):
            face_embedding = FaceEmbedding()
            embeddings = face_embedding.generate_embeddings(dirs["faces_dir"])

        with timer.timer("save_embeddings"):
            binary_output_path = os.path.join(dirs["embeddings_dir"], f"embedding-{direction}.npy")
            face_embedding.save_embeddings_binary(embeddings, binary_output_path)

        return {
            "direction": direction,
            "frames_extracted": len(frame_paths),
            "faces_detected": detect_results["total_faces"],
            "frames_processed": detect_results["processed_frames"],
            "embeddings_generated": len(embeddings),
        }

    try:
        tasks = [process_video(direction, video) for direction, video in video_with_directions]
        gathered_results = await asyncio.gather(*tasks, return_exceptions=True)
        results = []
        for result in gathered_results:
            if isinstance(result, Exception):
                traceback.print_exc()
                raise HTTPException(status_code=500, detail=str(result))
            else:
                results.append(result)
                print(f"Done with {result['direction']} video!")

        return {
            "status": "success",
            "message": "Videos processed successfully",
            "results": results,
            "facenet_status": timer.get_stats()
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
