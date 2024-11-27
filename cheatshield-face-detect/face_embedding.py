# face_embedding.py
import os
import json
import numpy as np
from PIL import Image
from facenet_pytorch import InceptionResnetV1

class FaceEmbedding:
    def __init__(self):
        """Initialize the FaceNet model for creating face embeddings"""
        self.model = InceptionResnetV1(pretrained='vggface2').eval()
        
    def _process_image(self, image_path):
        """
        Process a single image and prepare it for embedding
        
        Args:
            image_path: Path to the face image
            
        Returns:
            Processed image array ready for embedding
        """
        # Load and convert image
        image = Image.open(image_path)
        if image.mode != 'RGB':
            image = image.convert('RGB')
            
        # Convert to numpy array and normalize
        image_array = np.array(image)
        image_array = np.transpose(image_array, (2, 0, 1))
        image_array = image_array / 255.0
        image_array = np.expand_dims(image_array, axis=0)
        
        return image_array

    def generate_embeddings(self, faces_dir):
        """
        Generate embeddings for all face images in directory
        
        Args:
            faces_dir: Directory containing face images
            
        Returns:
            List of dictionaries containing embeddings and their confidence levels
        """
        embeddings_list = []
        face_files = [f for f in os.listdir(faces_dir) 
                     if f.lower().endswith(('.png', '.jpg', '.jpeg'))]
        
        print(f"Generating embeddings for {len(face_files)} faces...")
        
        for face_file in face_files:
            face_path = os.path.join(faces_dir, face_file)
            
            try:
                # Process image
                image_array = self._process_image(face_path)
                
                # Generate embedding
                embedding = self.model(image_array)
                
                # Convert embedding to list
                embedding_list = embedding.detach().numpy().squeeze().tolist()
                
                # Extract confidence from filename
                confidence = float(face_file.split("conf_")[1].split(".")[0])
                
                embeddings_list.append({
                    "embedding": embedding_list,
                    "confidence": confidence
                })
                
                print(f"Processed {face_file}")
                
            except Exception as e:
                print(f"Error processing {face_file}: {str(e)}")
                continue
        
        return embeddings_list

    def save_embeddings_json(self, embeddings, output_path):
        """
        Save embeddings in JSON format
        
        Args:
            embeddings: List of dictionaries containing embeddings and confidence levels
            output_path: Path to save the JSON file
        
        Returns:
            Dictionary containing embeddings and metadata
        """
        # Create output directory if it doesn't exist
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        
        # Prepare data with metadata
        data = {
            "embeddings": embeddings,
            "metadata": {
                "model": "facenet_vggface2",
                "embedding_size": len(embeddings[0]["embedding"]) if embeddings else 0,
                "total_faces": len(embeddings)
            }
        }
        
        # Save as JSON
        with open(output_path, 'w') as f:
            json.dump(data, f, indent=2)
            
        print(f"Saved JSON embeddings to: {output_path}")
        
        return data

    def save_embeddings_binary(self, embeddings, output_path):
        """
        Save embeddings in binary numpy format
        
        Args:
            embeddings: List of dictionaries containing embeddings and confidence levels
            output_path: Path to save the binary file
        
        Returns:
            Structured numpy array containing embeddings and confidence levels
        """
        # Create output directory if it doesn't exist
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        
        # Convert embeddings to structured numpy array
        dtype = [
            ('embedding', 'f4', (512,)),  # FaceNet embeddings are 512-dimensional
            ('confidence', 'f4')
        ]
        
        # Create numpy array
        embeddings_array = np.zeros(len(embeddings), dtype=dtype)
        
        for i, emb in enumerate(embeddings):
            embeddings_array[i] = (
                np.array(emb['embedding'], dtype='f4'),
                emb['confidence']
            )
        
        # Save as binary
        np.save(output_path, embeddings_array)
        print(f"Saved binary embeddings to: {output_path}")
        
        return embeddings_array

def load_embeddings_json(input_path):
    """
    Load embeddings from JSON file
    
    Args:
        input_path: Path to JSON embeddings file
        
    Returns:
        Dictionary containing embeddings and metadata
    """
    with open(input_path, 'r') as f:
        return json.load(f)

def load_embeddings_binary(input_path):
    """
    Load embeddings from binary file
    
    Args:
        input_path: Path to binary embeddings file
        
    Returns:
        Structured numpy array containing embeddings and confidence levels
    """
    return np.load(input_path, allow_pickle=True)