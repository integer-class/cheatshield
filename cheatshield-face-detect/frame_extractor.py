import os
import cv2
import asyncio

async def write_frame(path, frame):
    cv2.imwrite(path, frame)
    return path

async def extract_frames(video_path, output_directory):
    """
    Extract every single frame from video
    
    Args:
        video_path (str): Path to input video
        output_directory (str): Directory to save frames
    
    Returns:
        list: Paths of extracted frames
    """
    # Create output directory if not exists
    os.makedirs(output_directory, exist_ok=True)
    
    # Open video
    video = cv2.VideoCapture(video_path)
    
    frame_paths = []
    extract_count = 0
    frame_count = 0
    tasks = []

    while True:
        ret, frame = video.read()
        extract_count += 1
        
        if not ret:
            break

        # skip every other frame because we don't need every single one of them
        # which should make it faster
        if extract_count % 2 != 0:
            continue

        frame_count += 1
        resized_frame = cv2.resize(frame, (0, 0), fx = 0.5, fy = 0.5)
        frame_filename = os.path.join(output_directory, f"frame_{frame_count:04d}.png")
        tasks.append(write_frame(frame_filename, resized_frame))
    
    paths = await asyncio.gather(*tasks);
    video.release()
    return paths