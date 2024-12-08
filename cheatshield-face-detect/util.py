import os

def prepare_workspace_dir_for_user(user_id: str) -> dict[str, str]:
    workspace_dir = "workspace"
    user_workspace_dir = os.path.join(workspace_dir, f"user-{user_id}")
    input_video_path = os.path.join(workspace_dir, f"user-{user_id}", "input.mp4")
    frames_dir = os.path.join(workspace_dir, f"user-{user_id}", "frames")
    faces_dir = os.path.join(workspace_dir, f"user-{user_id}", "faces")
    processed_frames_dir = os.path.join(workspace_dir, f"user-{user_id}", "processed_frames")
    embeddings_dir = os.path.join(workspace_dir, f"user-{user_id}", "embeddings")

    # create every directory if it doesn't exist
    for dir in [workspace_dir,
                user_workspace_dir,
                frames_dir,
                faces_dir,
                processed_frames_dir,
                embeddings_dir]:
        if not os.path.exists(dir):
            os.makedirs(dir)

    return {
        "workspace_dir": workspace_dir,
        "user_workspace_dir": user_workspace_dir,
        "input_video_path": input_video_path,
        "frames_dir": frames_dir,
        "faces_dir": faces_dir,
        "processed_frames_dir": processed_frames_dir,
        "embeddings_dir": embeddings_dir
    }
