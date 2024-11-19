import cv2
import face_recognition
import numpy as np
from sklearn.datasets import fetch_lfw_people
from collections import Counter

def load_known_faces():
    print("Loading LFW dataset...")
    lfw_people = fetch_lfw_people(min_faces_per_person=70, resize=0.5)  # Reduced size
    
    known_faces = []
    known_names = []
    
    # Process faces in batches
    batch_size = 32
    for i in range(0, len(lfw_people.images), batch_size):
        batch_images = lfw_people.images[i:i+batch_size]
        batch_targets = lfw_people.target[i:i+batch_size]
        
        for face_img, target in zip(batch_images, batch_targets):
            face_img_uint8 = (face_img * 255).astype(np.uint8)
            face_img_rgb = np.dstack([face_img_uint8] * 3)
            
            face_encodings = face_recognition.face_encodings(face_img_rgb)
            if len(face_encodings) > 0:
                known_faces.append(face_encodings[0])
                known_names.append(lfw_people.target_names[target])
    
    return known_faces, known_names

def main():
    known_faces, known_names = load_known_faces()
    print(f"Loaded {len(known_faces)} known faces")

    cap = cv2.VideoCapture(0)
    
    # Process every N frames
    process_every_n_frames = 3
    frame_count = 0
    
    # Keep track of recent predictions for smoothing
    recent_predictions = []
    prediction_window = 5

    # Reduce resolution for faster processing
    frame_scale = 0.25

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        frame_count += 1
        
        # Only process every Nth frame
        if frame_count % process_every_n_frames != 0:
            # Still display the frame with the last known locations
            cv2.imshow('Face Recognition', frame)
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break
            continue

        # Resize frame for faster processing
        small_frame = cv2.resize(frame, (0, 0), fx=frame_scale, fy=frame_scale)
        rgb_small_frame = small_frame[:, :, ::-1]

        # Find faces in current frame
        face_locations = face_recognition.face_locations(rgb_small_frame, model="hog")  # Use HOG instead of CNN
        face_encodings = face_recognition.face_encodings(rgb_small_frame, face_locations)

        # Process each face in the frame
        for (top, right, bottom, left), face_encoding in zip(face_locations, face_encodings):
            # Scale back up face locations
            scale = int(1/frame_scale)
            top *= scale
            right *= scale
            bottom *= scale
            left *= scale

            # Use numpy for faster face comparison
            face_distances = face_recognition.face_distance(known_faces, face_encoding)
            best_match_index = np.argmin(face_distances)
            
            if face_distances[best_match_index] < 0.6:
                name = known_names[best_match_index]
            else:
                name = "Unknown"
            
            # Add to recent predictions for smoothing
            recent_predictions.append(name)
            if len(recent_predictions) > prediction_window:
                recent_predictions.pop(0)
            
            # Use most common prediction in recent window
            smoothed_name = Counter(recent_predictions).most_common(1)[0][0]

            # Draw rectangle and name
            cv2.rectangle(frame, (left, top), (right, bottom), (0, 255, 0), 2)
            cv2.rectangle(frame, (left, bottom - 35), (right, bottom), (0, 255, 0), cv2.FILLED)
            cv2.putText(frame, smoothed_name, (left + 6, bottom - 6), 
                       cv2.FONT_HERSHEY_DUPLEX, 0.6, (255, 255, 255), 1)

        cv2.imshow('Face Recognition', frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()
