import numpy as np
import cv2
import os
os.system("sudo modprobe bcm2835-v4l2")

cap = cv2.VideoCapture(0)
if cap.isOpened() == False:
    print('ERROR: Unable to open the camera')
else:
    print('Start grabbing, press a key on Live window to terminate')
    cv2.namedWindow('Live');
    while( cap.isOpened() ):
        ret,frame = cap.read()
        if ret==False:
            print('ERROR: Unable to grab from the camera')
            break;
 
        cv2.imshow('Live',frame)
        if cv2.waitKey(1) >= 0:
           break
    print('Closing the camera')
 
cap.release()
cv2.destroyAllWindows()
print('Done\n')