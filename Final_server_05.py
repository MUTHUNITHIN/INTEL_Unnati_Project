import cv2
import requests
from ultralytics import YOLO 

model = YOLO("color.pt")
esp32 = 'http://192.168.171.41'


cap = cv2.VideoCapture("http://192.168.161.37:4747/video")

while cap.isOpened():
    success, frame = cap.read()
    if success:

        results = model(frame)
        detected_colors = []
        
        for r in results:
            
            for box in r.boxes:
                label = box.cls[0] 
                if label in ['red', 'green', 'blue']:
                    detected_colors.append(label)

        
        if 'red' in detected_colors:
            requests.get(f"{esp32}/color/red")
        elif 'green' in detected_colors:
            requests.get(f"{esp32}/color/green")
        elif 'blue' in detected_colors:
            requests.get(f"{esp32}/color/blue")

        
        annotated_frame = results[0].plot()
        cv2.imshow("YOLO Inference", annotated_frame)
        
        if cv2.waitKey(1) & 0xFF == ord("q"):
            break
    else:
        break
        
cap.release()
cv2.destroyAllWindows()