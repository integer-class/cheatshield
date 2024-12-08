from collections.abc import Coroutine
import os
import cv2
import asyncio
from cv2.typing import MatLike

async def write_frame(path: str, frame: MatLike):
    _ = cv2.imwrite(path, frame)
    return path

async def extract_frames(video_path: str, output_directory: str):
    os.makedirs(output_directory, exist_ok=True)

    video = cv2.VideoCapture(video_path)

    extract_count = 0
    frame_count = 0
    tasks: list[Coroutine[str,str,str]] = []

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
        _ = tasks.append(write_frame(frame_filename, resized_frame))

    paths = await asyncio.gather(*tasks)
    video.release()
    return paths
