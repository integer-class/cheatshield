import io
import os
from typing import cast
import numpy as np
from PIL import Image
from numpy.typing import NDArray
import torch
from torch._prims_common import DeviceLikeType
from torch.functional import Tensor
from torch.nn import Embedding
import torchvision.transforms as transforms
from facenet_pytorch import InceptionResnetV1

class FaceEmbedding:
    device: DeviceLikeType
    model: InceptionResnetV1
    batch_size: int
    transform: transforms.Compose

    def __init__(self, batch_size: int = 32):
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        self.model = InceptionResnetV1(pretrained='vggface2').eval().to(self.device)
        self.batch_size = batch_size

        # Transformation for consistent image processing
        self.transform = transforms.Compose([
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.5, 0.5, 0.5], std=[0.5, 0.5, 0.5])
        ])

    def _process_image(self, image_path: str, target_size: tuple[int,int] =(160, 160)) -> Tensor:
        # Load and convert image
        image = Image.open(image_path)
        if image.mode != 'RGB':
            image = image.convert('RGB')

        image = image.resize(target_size, Image.LANCZOS)
        image_tensor = cast(Tensor, self.transform(image)).unsqueeze(0).to(self.device)

        return image_tensor

    def generate_embeddings(self, faces_dir: str):
        face_files = [f for f in os.listdir(faces_dir)
                    if f.lower().endswith(('.png', '.jpg', '.jpeg'))]

        # Process images in batches
        embeddings_list: list[dict[str,float|list[float]]] = []
        with torch.no_grad():
            for i in range(0, len(face_files), self.batch_size):
                batch_files = face_files[i:i+self.batch_size]
                batch_tensors: list[torch.Tensor] = []
                batch_metadata: list[dict[str, str|float]] = []

                for face_file in batch_files:
                    face_path = os.path.join(faces_dir, face_file)

                    try:
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

                padded_tensors: list[Tensor] = []
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

                batch_input = torch.cat(padded_tensors)
                batch_embeddings: list[Tensor] = self.model(batch_input)

                for j, embedding in enumerate(batch_embeddings):
                    embeddings_list.append({
                        "embedding": cast(list[float], cast(NDArray[np.float32], embedding.cpu().numpy()).tolist()),
                        "confidence": float(batch_metadata[j]["confidence"])
                    })

                # clear gpu cache periodically
                torch.cuda.empty_cache()

        return embeddings_list

    def save_embeddings_binary(self, embeddings: list[dict[str,Embedding]], output_path: str):
        os.makedirs(os.path.dirname(output_path), exist_ok=True)

        # Convert embeddings to structured numpy array
        dtype = [
            ('embedding', 'f4', (512,)),  # FaceNet embeddings are 512-dimensional
            ('confidence', 'f4')
        ]

        embeddings_array = np.zeros(len(embeddings), dtype=dtype)

        for i, emb in enumerate(embeddings):
            embeddings_array[i] = (
                np.array(emb['embedding'], dtype='f4'),
                emb['confidence']
            )

        np.save(output_path, embeddings_array)

        return embeddings_array

    def load_embeddings_binary(self, embeddings_dir: str) -> NDArray[np.float32]:
        embeddings_path = os.path.join(embeddings_dir, "embeddings.npy")
        embeddings_array: NDArray[np.float32] = np.load(embeddings_path, allow_pickle=False)

        return embeddings_array

    def match_face_with_embedding(self, frame: bytes, embeddings: NDArray[np.float32]) -> dict[str, float|list[float]]:
        image = Image.open(io.BytesIO(frame))
        if image.mode != 'RGB':
            image = image.convert('RGB')

        image = image.resize((320, 320), Image.LANCZOS)
        image_tensor = cast(Tensor, self.transform(image)).unsqueeze(0).to(self.device)

        # Skip empty images
        if image.width == 0 or image.height == 0:
            return {
                "embedding": [],
                "confidence": 0.0
            }

        with torch.no_grad():
            # Generate embedding for the given frame
            frame_embedding = self.model(image_tensor).cpu().numpy()

            # Compare the frame embedding with all embeddings in the database
            similarities = np.dot(embeddings['embedding'], frame_embedding.T)
            best_match_index = np.argmax(similarities)
            best_match_confidence = similarities[best_match_index]

            return {
                "embedding": embeddings[best_match_index]['embedding'].tolist(),
                "confidence": float(best_match_confidence)
            }
