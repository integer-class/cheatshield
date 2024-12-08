# main.py
import os
import shutil
from fastapi import FastAPI, UploadFile, File, HTTPException
from frame_extractor import extract_frames
from face_detector import detect_faces_in_frames
from timer import PerformanceTimer
from face_embedding import FaceEmbedding
from face_orientation_sorter import process_face_orientations  # Import the new module

app = FastAPI()

WORKSPACE_DIR = "workspace"
INPUT_VIDEO_PATH = os.path.join(WORKSPACE_DIR, "input.mp4")
FRAMES_DIR = os.path.join(WORKSPACE_DIR, "frames")
FACES_DIR = os.path.join(WORKSPACE_DIR, "faces")
PROCESSED_FRAMES_DIR = os.path.join(WORKSPACE_DIR, "processed_frames")
EMBEDDINGS_DIR = os.path.join(WORKSPACE_DIR, "embeddings")

@app.post("/upload-video")
async def upload_video(file: UploadFile = File(...)):
    """
    Upload video file, extract frames, detect faces, and generate embeddings
    """
    try:
        # Create workspace directories
        os.makedirs(WORKSPACE_DIR, exist_ok=True)
        os.makedirs(FRAMES_DIR, exist_ok=True)
        os.makedirs(FACES_DIR, exist_ok=True)
        os.makedirs(PROCESSED_FRAMES_DIR, exist_ok=True)
        os.makedirs(EMBEDDINGS_DIR, exist_ok=True)

        # Clean up previous files
        for dir_path in [FRAMES_DIR, FACES_DIR, PROCESSED_FRAMES_DIR, EMBEDDINGS_DIR]:
            for file_name in os.listdir(dir_path):
                file_path = os.path.join(dir_path, file_name)
                try:
                    if os.path.isfile(file_path):
                        os.unlink(file_path)
                except Exception as e:
                    print(f"Error: {e}")

        # Save uploaded video
        with open(INPUT_VIDEO_PATH, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        timer = PerformanceTimer()

        with timer.timer("Frame Extraction"):
            # Extract frames
            frame_paths = await extract_frames(INPUT_VIDEO_PATH, FRAMES_DIR)
            
        with timer.timer("Face Detection"):
            # Detect faces
            results = await detect_faces_in_frames(FRAMES_DIR, FACES_DIR, PROCESSED_FRAMES_DIR)
        
        with timer.timer("Face Orientation Sorting"):
            # Sort faces by orientation
            best_faces, orientation_summary = process_face_orientations(FACES_DIR)
        
        with timer.timer("Embedding Generation"):
            # Generate embeddings
            face_embedding = FaceEmbedding()
            
            # Prepare for orientation-specific embeddings
            orientation_embeddings = {}
            
            # Generate embeddings for each orientation directory
            for orientation, dir_path in best_faces.items():
                orientation_dir = os.path.join(FACES_DIR, orientation)
                
                # Only generate embeddings if the directory exists and has files
                if os.path.exists(orientation_dir) and os.listdir(orientation_dir):
                    embeddings = face_embedding.generate_embeddings(orientation_dir)
                    
                    # Save embeddings in binary format
                    binary_output_path = os.path.join(EMBEDDINGS_DIR, f"{orientation}_embeddings.npy")
                    face_embedding.save_embeddings_binary(embeddings, binary_output_path)
                    
                    orientation_embeddings[orientation] = {
                        "count": len(embeddings),
                        "file": binary_output_path
                    }
        
        return {
            "status": "success",
            "message": "Video processed successfully",
            "frames_extracted": len(frame_paths),
            "faces_detected": results["total_faces"],
            "frames_processed": results["processed_frames"],
            "face_orientations": orientation_summary,
            "orientation_embeddings": orientation_embeddings,
            "facenet_status": timer.get_stats()
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/")
async def root():
    return {"message": "Face Detection API"}