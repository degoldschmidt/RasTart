sudo modprobe bcm2835-v4l2
g++ $(pkg-config --libs --cflags opencv) -o grab grab.cpp
./grab