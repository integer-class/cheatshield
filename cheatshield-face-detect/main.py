import os
import shutil
from typing import Annotated, Any
from fastapi import FastAPI, File, Form, UploadFile, HTTPException
from frame_extractor import extract_frames
from face_detector import detect_faces_in_frames
from timer import PerformanceTimer
from face_embedding import FaceEmbedding
from pydantic import BaseModel
import torch

from util import prepare_workspace_dir_for_user

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

class GenerateEmbeddingRequest(BaseModel):
    video: Annotated[UploadFile, File(...)]
    user_id: Annotated[str, Form()]

@app.post("/api/v1/face-recognition/embedding")
async def generate_embedding(user_id: Annotated[str,Form()], video: Annotated[UploadFile, File(...)]) -> dict[str, Any]:
    """
    Generates embeddings for the faces in the uploaded video
    """

    timer = PerformanceTimer()

    dirs = prepare_workspace_dir_for_user(user_id)

    try:
        with timer.timer("Clean up files for user"):
            for file_name in os.listdir(dirs['user_workspace_dir']):
                file_path = os.path.join(dirs['user_workspace_dir'], file_name)
                if os.path.isfile(file_path):
                    os.unlink(file_path)

        with timer.timer("Save uploaded file into a buffer"):
            with open(dirs["input_video_path"], "wb") as buffer:
                shutil.copyfileobj(video.file, buffer)

        with timer.timer("Extract frames"):
            frame_paths = await extract_frames(dirs["input_video_path"], dirs["frames_dir"])

        with timer.timer("Detect faces"):
            results = await detect_faces_in_frames(
                frames_dir=dirs["frames_dir"],
                faces_dir=dirs["faces_dir"],
                processed_dir=dirs["processed_frames_dir"]
            )

        with timer.timer("Generate embeddings"):
            face_embedding = FaceEmbedding()
            embeddings = face_embedding.generate_embeddings(dirs["faces_dir"])

        with timer.timer("Save embeddings"):
            binary_output_path = os.path.join(dirs["embeddings_dir"], "embeddings.npy")
            face_embedding.save_embeddings_binary(embeddings, binary_output_path)

        return {
            "status": "success",
            "message": "Video processed successfully",
            "frames_extracted": len(frame_paths),
            "faces_detected": results["total_faces"],
            "frames_processed": results["processed_frames"],
            "embeddings_generated": len(embeddings),
            # "embeddings_json": json_data,
            # "embeddings_binary": binary_data.tolist(),
            "facenet_status": timer.get_stats()
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/v1/face-recognition/check")
async def check_face_position():
    """
    Checks if the frame being sent matches the face in the embedding database
    """

