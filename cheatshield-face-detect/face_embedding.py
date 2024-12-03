import os
import numpy as np
from PIL import Image
import torch
import torchvision.transforms as transforms
from facenet_pytorch import InceptionResnetV1

class FaceEmbedding:
    def __init__(self, batch_size=32):
        """
        Initialize the FaceNet model with GPU optimization
        
        Args:
            batch_size: Number of images to process in one batch
        """
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        self.model = InceptionResnetV1(pretrained='vggface2').eval().to(self.device)
        self.batch_size = batch_size
        
        # Transformation for consistent image processing
        self.transform = transforms.Compose([
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.5, 0.5, 0.5], std=[0.5, 0.5, 0.5])
        ])

        print(self.device)

    def _process_image(self, image_path, target_size=(160, 160)):
        """
        Process a single image with optional resizing
        """
        # Load and convert image
        image = Image.open(image_path)
        if image.mode != 'RGB':
            image = image.convert('RGB')
        
        # Resize image to a standard size
        image = image.resize(target_size, Image.LANCZOS)
        
        # Convert to PyTorch tensor and normalize
        image_tensor = self.transform(image).unsqueeze(0).to(self.device)
        
        return image_tensor

    def generate_embeddings(self, faces_dir):
        """
        Generate embeddings for all face images in directory with batch processing
        
        Args:
            faces_dir: Directory containing face images
            
        Returns:
            List of dictionaries containing embeddings and their confidence levels
        """
        embeddings_list = []
        face_files = [f for f in os.listdir(faces_dir) 
                    if f.lower().endswith(('.png', '.jpg', '.jpeg'))]
        
        print(f"Generating embeddings for {len(face_files)} faces...")
        
        # Process images in batches
        with torch.no_grad():
            for i in range(0, len(face_files), self.batch_size):
                batch_files = face_files[i:i+self.batch_size]
                batch_tensors = []
                batch_metadata = []
                
                for face_file in batch_files:
                    face_path = os.path.join(faces_dir, face_file)
                    
                    try:
                        # Process image
                        image_tensor = self._process_image(face_path)
                        batch_tensors.append(image_tensor)
                        
                        # Extract confidence from filename
                        confidence = float(face_file.split("conf_")[1].split(".")[0])
                        batch_metadata.append({
                            "filename": face_file,
                            "confidence": confidence
                        })
                        
                    except Exception as e:
                        print(f"Error processing {face_file}: {str(e)}")
                        continue
                
                # Skip if no valid images in batch
                if not batch_tensors:
                    continue
                
                # Ensure consistent tensor sizes using padding or resizing
                max_height = max(tensor.shape[2] for tensor in batch_tensors)
                max_width = max(tensor.shape[3] for tensor in batch_tensors)
                
                padded_tensors = []
                for tensor in batch_tensors:
                    # Pad tensor to max dimensions
                    pad_height = max_height - tensor.shape[2]
                    pad_width = max_width - tensor.shape[3]
                    
                    padded_tensor = torch.nn.functional.pad(tensor, 
                        (0, pad_width, 0, pad_height), 
                        mode='constant', 
                        value=0
                    )
                    padded_tensors.append(padded_tensor)
                
                # Batch processing
                batch_input = torch.cat(padded_tensors)
                batch_embeddings = self.model(batch_input)
                
                # Convert and process batch embeddings
                for j, embedding in enumerate(batch_embeddings):
                    embeddings_list.append({
                        "embedding": embedding.cpu().numpy().tolist(),
                        "confidence": batch_metadata[j]["confidence"]
                    })
                    
                    print(f"Processed {batch_metadata[j]['filename']}")
                
                # Clear GPU cache periodically
                torch.cuda.empty_cache()
        
        return embeddings_list

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