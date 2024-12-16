import os
import cv2
import asyncio

async def extract_frames(video_path: str, output_directory: str, loop: asyncio.AbstractEventLoop):
    os.makedirs(output_directory, exist_ok=True)

    video = cv2.VideoCapture(video_path)

    extract_count = 0
    frame_count = 0

    paths: list[str] = []
    while True:
        ret, frame = video.read()
        extract_count += 1

        if not ret:
            break

        # skip every other frame because we don't need every single one of them
        # which should make it faster
        if extract_count % 5 != 0:
            continue

        frame_count += 1
        resized_frame = cv2.resize(frame, (0, 0), fx = 0.5, fy = 0.5)
        frame_filename = os.path.join(output_directory, f"frame_{frame_count:04d}.png")
        paths.append(frame_filename)
        _ = await loop.run_in_executor(None, lambda: cv2.imwrite(frame_filename, resized_frame))

    video.release()
    return paths
