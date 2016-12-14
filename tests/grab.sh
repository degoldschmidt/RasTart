g++ $(pkg-config --libs --cflags opencv) -o grab grab.cpp
./grab