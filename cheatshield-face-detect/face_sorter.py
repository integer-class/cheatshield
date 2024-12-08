import os
from typing import cast
import cv2
from cv2.typing import MatLike, Rect
import numpy as np
import shutil

class FaceAnalyzer:
    face_cascade: cv2.CascadeClassifier

    def __init__(self):
        self.face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')

    def detect_face(self, image: MatLike) -> Rect|None:
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        faces = self.face_cascade.detectMultiScale(
            gray,
            scaleFactor=1.05,
            minNeighbors=6,
            minSize=(60, 60),
            maxSize=(800, 800)
        )

        if len(faces) == 0:
            return None

        # Return largest face
        return sorted(faces, key=lambda x: x[2] * x[3], reverse=True)[0]

    def analyze_yaw(self, image: MatLike, face: Rect) -> float:
        x, _y, w, _h = face
        image_width = image.shape[1]

        face_center_x = x + w/2
        relative_x = face_center_x / image_width
        yaw_angle = abs((relative_x - 0.5) * 90)

        return yaw_angle

    def analyze_pitch(self, image: MatLike, face: Rect) -> float:
        _x, y, _w, h = face
        image_height = image.shape[0]

        face_center_y = y + h/2
        relative_y = face_center_y / image_height
        pitch_angle = abs((relative_y - 0.5) * 90)  # Convert to degrees

        return pitch_angle

    def analyze_roll(self, image: MatLike, face: Rect) -> float:
        x, y, w, h = face
        face_roi = image[y:y+h, x:x+w]
        gray_roi = cv2.cvtColor(face_roi, cv2.COLOR_BGR2GRAY)

        # Use gradient direction to estimate roll
        # This is a simplified approach - could be improved with eye detection
        gradient_x = cv2.Sobel(gray_roi, cv2.CV_64F, 1, 0, ksize=3)
        gradient_y = cv2.Sobel(gray_roi, cv2.CV_64F, 0, 1, ksize=3)
        roll_angle = abs(
            cast(float, np.arctan2(np.mean(gradient_y), np.mean(gradient_x)) * 180 / np.pi)
        )

        return roll_angle

    def analyze_blur(self, image: MatLike, face: Rect) -> float:
        x, y, w, h = face
        face_roi = image[y:y+h, x:x+w]
        gray_roi = cv2.cvtColor(face_roi, cv2.COLOR_BGR2GRAY)

        laplacian_var = cast(float, cv2.Laplacian(gray_roi, cv2.CV_64F).var())

        # FFT-based blur detection
        rows, cols = gray_roi.shape
        crow, ccol = rows//2, cols//2
        f = np.fft.fft2(gray_roi)
        fshift = np.fft.fftshift(f)
        magnitude_spectrum = 20 * np.log(np.abs(fshift))
        fft_score = cast(float, magnitude_spectrum[crow-5:crow+5, ccol-5:ccol+5].mean())

        # Combine scores
        blur_score = (laplacian_var + fft_score) / 2

        return blur_score

def sort_and_select_best_frames(frames_directory: str, sorted_directory: str, top_n: int = 5) -> list[str]:
    os.makedirs(sorted_directory, exist_ok=True)

    analyzer = FaceAnalyzer()
    frame_data: list[dict[str,str|dict[str,float]]] = []

    # Process all frames
    for filename in os.listdir(frames_directory):
        if not filename.lower().endswith(('.png', '.jpg', '.jpeg')):
            continue

        frame_path = os.path.join(frames_directory, filename)
        image = cv2.imread(frame_path)

        if image is None:
            continue

        face = analyzer.detect_face(image)
        if face is not None:
            # Calculate all metrics
            metrics = {
                'yaw': analyzer.analyze_yaw(image, face),
                'pitch': analyzer.analyze_pitch(image, face),
                'roll': analyzer.analyze_roll(image, face),
                'blur': analyzer.analyze_blur(image, face)
            }

            frame_info = {
                'path': frame_path,
                'metrics': metrics,
                'filename': filename
            }
            frame_data.append(frame_info)

    # Score and sort frames
    def calculate_frame_score(frame_info: dict[str, dict[str, float]]) -> float:
        metrics = frame_info['metrics']

        # Weights for different metrics
        weights = {
            'yaw': 1.0,
            'pitch': 1.0,
            'roll': 1.0,
            'blur': 2.0  # Higher weight for blur
        }

        # Calculate weighted score (lower is better for angles, higher is better for blur)
        angle_score: float = (
            metrics['yaw'] * weights['yaw'] +
            metrics['pitch'] * weights['pitch'] +
            metrics['roll'] * weights['roll']
        )
        blur_score = -metrics['blur'] * weights['blur']  # Negative because higher blur value is better

        return -(angle_score + blur_score)  # Negative for descending sort

    # Sort frames by total score
    sorted_frames = sorted(frame_data, key=calculate_frame_score)

    # Export best frames
    best_frame_paths = []
    for i, frame_info in enumerate(sorted_frames[:top_n]):
        source_path = frame_info['path']
        metrics = frame_info['metrics']

        # Create filename with metrics
        dest_filename = (f"best_frame_{i:02d}"
                        f"_yaw{metrics['yaw']:.1f}"
                        f"_pitch{metrics['pitch']:.1f}"
                        f"_roll{metrics['roll']:.1f}"
                        f"_blur{metrics['blur']:.1f}.png")
        dest_path = os.path.join(sorted_directory, dest_filename)

        # Copy frame to sorted directory
        shutil.copy(source_path, dest_path)
        best_frame_paths.append(dest_path)

        # Save metrics to text file
        metrics_path = os.path.join(sorted_directory, f"best_frame_{i:02d}_metrics.txt")
        with open(metrics_path, 'w') as f:
            for key, value in metrics.items():
                f.write(f"{key}: {value:.2f}\n")

    return best_frame_paths

def main():
    # Test the function
    frames_dir = "workspace/frames"
    sorted_dir = "workspace/sorted_frames"
    best_frames = sort_and_select_best_frames(frames_dir, sorted_dir)
    print(f"Best frames saved to: {sorted_dir}")

if __name__ == "__main__":
    main()
