from concurrent.futures import ThreadPoolExecutor
import os
import shutil
import traceback
import asyncio
from typing import Annotated, Any
from fastapi import FastAPI, File, Form, Header, UploadFile, HTTPException
from frame_extractor import extract_frames
from face_detector import detect_faces_in_frames
from timer import PerformanceTimer
from face_embedding import FaceEmbedding
import torch

from util import prepare_workspace_dir_for_user

print("Face Detection API")
print("Is CUDA Available: ", torch.cuda.is_available())

app = FastAPI(debug=True)
API_TOKEN = os.getenv("API_TOKEN")

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
    right_video: Annotated[UploadFile, Form(...)],
    token: Annotated[str|None, Header()],
) -> dict[str, Any]:
    """
    Generates embeddings for the faces in the uploaded videos
    """

    if token is None:
        raise HTTPException(status_code=401, detail="Token is required")

    if token != API_TOKEN:
        raise HTTPException(status_code=401, detail="Invalid token")

    timer = PerformanceTimer()

    dirs = prepare_workspace_dir_for_user(user_id)

    video_with_directions = zip(
        ["straight", "up", "down", "left", "right"],
        [straight_video, up_video, down_video, left_video, right_video]
    )

    async def process_video(direction: str, video: UploadFile, loop: asyncio.AbstractEventLoop):
        print(f"Processing {direction} video...")
        input_video_path = os.path.join(dirs["input_video_dir"], f"video_{direction}.mp4")
        _ = await loop.run_in_executor(None, lambda: shutil.copyfileobj(video.file, open(input_video_path, "wb")))

        with timer.timer("extract_frames"):
            frame_paths = await extract_frames(
                video_path=input_video_path,
                output_directory=dirs["frames_dirs"][direction],
                loop=loop
            )

        with timer.timer("detect_faces"):
            detect_results = await detect_faces_in_frames(
                frames_dir=dirs["frames_dirs"][direction],
                faces_dir=dirs["faces_dirs"][direction],
                processed_dir=dirs["processed_frames_dirs"][direction]
            )

        with timer.timer("generate_embeddings"):
            face_embedding = FaceEmbedding()
            embeddings = face_embedding.generate_embeddings(
                faces_dir=dirs["faces_dirs"][direction]
            )

        with timer.timer("save_embeddings"):
            binary_output_path = os.path.join(dirs["embeddings_dir"], f"embedding_{direction}.npy")
            face_embedding.save_embeddings_binary(embeddings, binary_output_path)

        return {
            "direction": direction,
            "frames_extracted": len(frame_paths),
            "faces_detected": detect_results["total_faces"],
            "frames_processed": detect_results["processed_frames"],
            "embeddings_generated": len(embeddings),
        }

    try:
        with ThreadPoolExecutor() as executor:
            print("Processing tasks in thread pool executor")
            loop = asyncio.get_running_loop()
            tasks = [
                process_video(direction, video, loop)
                for direction, video in video_with_directions
            ]
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

@app.post("/api/v1/face-recognition/check")
async def check_face_position(
    user_id: Annotated[str,Form()],
    frame: Annotated[UploadFile, File(...)],
    token: Annotated[str|None, Header()]
) -> dict[str, Any]:
    """
    Checks if the frame being sent matches the face in the embedding database
    """

    if token is None:
        raise HTTPException(status_code=401, detail="Token is required")

    if token != API_TOKEN:
        raise HTTPException(status_code=401, detail="Invalid token")

    timer = PerformanceTimer()

    dirs = prepare_workspace_dir_for_user(user_id)

    try:
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
