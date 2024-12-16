import os
import shutil

def prepare_workspace_dir_for_user(user_id: str) -> dict[str, str|dict[str,str]]:
    workspace_dir = "workspace"
    user_workspace_dir = os.path.join(workspace_dir, f"user-{user_id}")
    input_video_dir = os.path.join(workspace_dir, f"user-{user_id}", "input_videos")

    faces_directions = ["straight", "up", "down", "left", "right"]
    frames_dirs: dict[str,str] = {}
    faces_dirs: dict[str,str]  = {}
    processed_frames_dirs: dict[str,str]  = {}
    for direction in faces_directions:
        frames_dirs[direction] = os.path.join(workspace_dir, f"user-{user_id}", f"frames_{direction}")
        faces_dirs[direction] = os.path.join(workspace_dir, f"user-{user_id}", f"faces_{direction}")
        processed_frames_dirs[direction] = os.path.join(workspace_dir, f"user-{user_id}", f"processed_frames_{direction}")

    embeddings_dir = os.path.join(workspace_dir, f"user-{user_id}", "embeddings")

    # create every directory if it doesn't exist
    try:
        for dir in [user_workspace_dir,
                    input_video_dir,
                    embeddings_dir]:
            if os.path.exists(dir):
                shutil.rmtree(dir)
            else:
                os.makedirs(dir)
    except Exception as e:
        print(f"Error creating directories: {str(e)}")

    try:
        for dir_dict in [frames_dirs, faces_dirs, processed_frames_dirs]:
            for dir_path in dir_dict.values():
                if os.path.exists(dir_path):
                    shutil.rmtree(dir_path)
                else:
                    os.makedirs(dir_path)
    except Exception as e:
        print(f"Error creating directories: {str(e)}")

    return {
        "workspace_dir": workspace_dir,
        "user_workspace_dir": user_workspace_dir,
        "input_video_dir": input_video_dir,
        "frames_dirs": frames_dirs,
        "faces_dirs": faces_dirs,
        "processed_frames_dirs": processed_frames_dirs,
        "embeddings_dir": embeddings_dir
    }
