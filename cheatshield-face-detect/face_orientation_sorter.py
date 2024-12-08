import os
import numpy as np
import torch
import torchvision.transforms as transforms
from PIL import Image
from facenet_pytorch import MTCNN

class FaceOrientationSorter:
    def __init__(self):
        # Initialize MTCNN for face detection and landmark estimation
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        self.mtcnn = MTCNN(
            keep_all=True,
            device=self.device,
            select_largest=False,
            post_process=False,
            margin=20,
            min_face_size=20
        )
        
        # Workspace directories
        self.base_faces_dir = "workspace/faces"
        self.orientation_dirs = {
            "straight": os.path.join(self.base_faces_dir, "straight"),
            "left": os.path.join(self.base_faces_dir, "left_profile"),
            "right": os.path.join(self.base_faces_dir, "right_profile"),
            "up": os.path.join(self.base_faces_dir, "up"),
            "down": os.path.join(self.base_faces_dir, "down")
        }
        
        # Create directories if they don't exist
        for dir_path in self.orientation_dirs.values():
            os.makedirs(dir_path, exist_ok=True)

    def _estimate_face_orientation(self, landmarks):
        """
        Estimate face orientation based on facial landmarks
        
        Args:
            landmarks (np.ndarray): Facial landmarks 
            
        Returns:
            str: Estimated orientation
        """
        if landmarks is None or len(landmarks) < 5:
            return None
        
        try:
            # More robust landmark point extraction
            # Assuming landmarks might have different structures
            def get_point(index):
                """Safely get landmark point"""
                try:
                    return landmarks[index]
                except IndexError:
                    return None
            
            # Get key landmark points
            left_eye = get_point(0)  # Left eye
            right_eye = get_point(1)  # Right eye
            
            # Fallback if eyes are not available
            if left_eye is None or right_eye is None:
                return "straight"
            
            # Calculate eye midpoint
            eye_midpoint = (left_eye + right_eye) / 2
            
            # Try to get nose point (might be at different index)
            nose = get_point(2)  # Typically nose
            if nose is None and len(landmarks) > 2:
                nose = landmarks[2]  # Try alternative index
            
            # If no nose point, use midpoint
            if nose is None:
                nose = eye_midpoint
            
            # Calculate angles
            yaw_angle = np.degrees(np.arctan2(
                nose[0] - eye_midpoint[0], 
                nose[1] - eye_midpoint[1]
            ))
            
            # Vertical angle (pitch)
            pitch_angle = np.degrees(np.arctan2(
                nose[1] - eye_midpoint[1],
                nose[0] - eye_midpoint[0]
            ))
            
            # Classify orientation with more tolerance
            if abs(yaw_angle) < 45 and abs(pitch_angle) < 45:
                return "straight"
            elif yaw_angle <= -45:
                return "right"
            elif yaw_angle >= 45:
                return "left"
            elif pitch_angle <= -45:
                return "down"
            elif pitch_angle >= 45:
                return "up"
            
            return "straight"
        except Exception as e:
            print(f"Error in orientation estimation: {e}")
            return None

    def sort_faces(self, faces_dir):
        """
        Sort faces by orientation and select top 3 for each direction
        
        Args:
            faces_dir (str): Directory containing face images
        
        Returns:
            dict: Sorted faces for each orientation
        """
        # Dictionaries to store faces by orientation
        orientation_faces = {
            "straight": [],
            "left": [],
            "right": [],
            "up": [],
            "down": []
        }
        
        # Process each face image
        for filename in os.listdir(faces_dir):
            if not filename.lower().endswith(('.png', '.jpg', '.jpeg')):
                continue
            
            face_path = os.path.join(faces_dir, filename)
            
            try:
                # Read image with PIL
                image = Image.open(face_path)
                if image.mode != 'RGB':
                    image = image.convert('RGB')
                
                # Detect faces and landmarks
                faces = self.mtcnn(image)
                
                # If no faces detected, skip
                if faces is None:
                    continue
                
                # Convert to numpy if tensor
                if isinstance(faces, torch.Tensor):
                    faces = faces.detach().numpy()
                
                # Skip if no faces or landmarks
                if len(faces) == 0:
                    continue
                
                # Get confidence from filename
                try:
                    confidence = float(filename.split("conf_")[1].split(".")[0])
                except:
                    confidence = 0.5  # default confidence if parsing fails
                
                # Estimate orientation
                orientation = self._estimate_face_orientation(faces[0])
                
                if orientation:
                    face_data = {
                        "path": face_path,
                        "confidence": confidence
                    }
                    orientation_faces[orientation].append(face_data)
            
            except Exception as e:
                print(f"Error processing {filename}: {e}")
                continue
        
        # Sort and select top 3 for each orientation
        best_faces = {}
        for orientation, faces in orientation_faces.items():
            # Sort by confidence, take top 3
            sorted_faces = sorted(faces, key=lambda x: x['confidence'], reverse=True)[:3]
            best_faces[orientation] = sorted_faces
            
            # Move and rename top 3 faces
            for i, face_data in enumerate(sorted_faces):
                dest_filename = f"{orientation}_face_{i+1}_conf_{face_data['confidence']:.2f}.png"
                dest_path = os.path.join(self.orientation_dirs[orientation], dest_filename)
                
                # Copy face to new directory
                image = Image.open(face_data['path'])
                image.save(dest_path)
        
        return best_faces

def process_face_orientations(faces_dir):
    """
    Main function to sort faces by orientation
    
    Args:
        faces_dir (str): Directory containing face images
    
    Returns:
        tuple: Best faces and their count by orientation
    """
    # Initialize sorter
    sorter = FaceOrientationSorter()
    
    # Sort faces from detected faces directory
    best_faces = sorter.sort_faces(faces_dir)
    
    # Print summary
    print("Face Orientation Sorting Complete:")
    orientation_summary = {}
    for orientation, faces in best_faces.items():
        count = len(faces)
        orientation_summary[orientation] = count
        print(f"{orientation.capitalize()} Faces: {count}")
    
    return best_faces, orientation_summary