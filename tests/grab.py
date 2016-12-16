import numpy as np
import cv2
import os
from imutils.video import FPS
os.system("sudo modprobe bcm2835-v4l2")
fps = FPS().start()

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

        cv2.imshow('Live ({:.2f})'.format(fps.fps()),frame)
        fps.update()
        if cv2.waitKey(1) >= 0:
           break
    print('Closing the camera')

cap.release()
cv2.destroyAllWindows()
# stop the timer and display FPS information
fps.stop()
print("[INFO] elasped time: {:.2f}".format(fps.elapsed()))
print("[INFO] approx. FPS: {:.2f}".format(fps.fps()))
print('Done\n')
