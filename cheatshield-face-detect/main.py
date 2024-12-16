import os
import shutil
import json
import traceback
from typing import Annotated, Any
from fastapi import FastAPI, File, Form, UploadFile, HTTPException
from frame_extractor import extract_frames
from face_detector import detect_faces_in_frames
from timer import PerformanceTimer
from face_embedding import FaceEmbedding
from pydantic import BaseModel
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
    up_video: Annotated[UploadFile, Form(...)],
    down_video: Annotated[UploadFile, Form(...)],
    left_video: Annotated[UploadFile, Form(...)],
    right_video: Annotated[UploadFile, Form(...)]) -> dict[str, Any]:
    """
    Generates embeddings for the faces in the uploaded videos
    """

    timer = PerformanceTimer()

    dirs = prepare_workspace_dir_for_user(user_id)

    video_with_directions = zip(
        ["up", "down", "left", "right"],
        [up_video, down_video, left_video, right_video]
    )

    try:
        results: list[dict[str, Any]] = []
        for direction, video in video_with_directions:
            print(f"Processing {direction} video...")
            with timer.timer("clean_up_workspace"):
                clean_up_workspace_dir_for_user(dirs)

            with timer.timer("save_uploaded_files_into_workspace"):
                input_video_path = os.path.join(dirs["input_video_dir"], f"video-{direction}.mp4")
                with open(input_video_path, "wb") as buffer:
                    shutil.copyfileobj(video.file, buffer)

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

            results.append({
                "direction": direction,
                "frames_extracted": len(frame_paths),
                "faces_detected": detect_results["total_faces"],
                "frames_processed": detect_results["processed_frames"],
                "embeddings_generated": len(embeddings),
            })
            print(f"Done with {direction} video!")

        return {
            "status": "success",
            "message": "Videos processed successfully",
            "results": results,
            "facenet_status": timer.get_stats()
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/v1/face-recognition/check")
async def check_face_position(user_id: Annotated[str,Form()], frame: Annotated[UploadFile, File(...)]):
    """
    Checks if the frame being sent matches the face in the embedding database
    """

    timer = PerformanceTimer()

    dirs = prepare_workspace_dir_for_user(user_id)

    try:
        with timer.timer("Clean up files for user"):
            clean_up_workspace_dir_for_user(dirs)

        with timer.timer("Load embeddings"):
            face_embedding = FaceEmbedding()
            embeddings = face_embedding.load_embeddings_binary(dirs["embeddings_dir"])

        with timer.timer("Match with embeddings"):
            frame_bytes = await frame.read()
            result = face_embedding.match_face_with_embedding(frame_bytes, embeddings)

        return {
            "status": "success",
            "message": "Frame processed successfully",
            "frame_processed": result,
            "facenet_status": timer.get_stats()
        }
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))
