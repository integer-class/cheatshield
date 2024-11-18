import cv2
import face_recognition
import numpy as np
from sklearn.datasets import fetch_lfw_people

def load_known_faces():
    # Load LFW dataset from scikit-learn
    print("Loading LFW dataset...")
    lfw_people = fetch_lfw_people(min_faces_per_person=70, resize=1.0)
    
    known_faces = []
    known_names = []
    
    # Process each face in the dataset
    for face_img, target in zip(lfw_people.images, lfw_people.target):
        # Convert to uint8 and get face encoding
        face_img_uint8 = (face_img * 255).astype(np.uint8)
        face_encodings = face_recognition.face_encodings(face_img_uint8)
        
        if len(face_encodings) > 0:
            known_faces.append(face_encodings[0])
            known_names.append(lfw_people.target_names[target])
    
    return known_faces, known_names

def main():
    # Load known faces
    known_faces, known_names = load_known_faces()
    print(f"Loaded {len(known_faces)} known faces")

    # Initialize webcam
    cap = cv2.VideoCapture(0)

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        # Resize frame for faster face recognition processing
        small_frame = cv2.resize(frame, (0, 0), fx=0.25, fy=0.25)
        
        # Convert BGR to RGB
        rgb_small_frame = small_frame[:, :, ::-1]

        # Find faces in current frame
        face_locations = face_recognition.face_locations(rgb_small_frame)
        face_encodings = face_recognition.face_encodings(rgb_small_frame, face_locations)

        # Process each face in the frame
        for (top, right, bottom, left), face_encoding in zip(face_locations, face_encodings):
            # Scale back up face locations
            top *= 4
            right *= 4
            bottom *= 4
            left *= 4

            # Check if the face matches any known faces
            matches = face_recognition.compare_faces(known_faces, face_encoding, tolerance=0.6)

            name = "Unknown"

            if True in matches:
                first_match_index = matches.index(True)
                name = known_names[first_match_index]

            # Draw rectangle around face
            cv2.rectangle(frame, (left, top), (right, bottom), (0, 255, 0), 2)

            # Draw name label
            cv2.rectangle(frame, (left, bottom - 35), (right, bottom), (0, 255, 0), cv2.FILLED)
            font = cv2.FONT_HERSHEY_DUPLEX
            cv2.putText(frame, name, (left + 6, bottom - 6), font, 0.6, (255, 255, 255), 1)

        # Display the frame
        cv2.imshow('Face Recognition', frame)

        # Press 'q' to quit
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()
