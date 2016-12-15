###
#   RasTart v1.0 - Shell script for preparing Raspbian
#   By: Dennis Goldschmidt
#   Last edit: 14/12/2016
###
echo "-------------------------------------------------"
echo "######                #######                    "                    
echo "#     #   ##    ####     #      ##   #####  #####" 
echo "#     #  #  #  #         #     #  #  #    #   #  " 
echo "######  #    #  ####     #    #    # #    #   #  " 
echo "#   #   ######      #    #    ###### #####    #  " 
echo "#    #  #    # #    #    #    #    # #   #    #  " 
echo "#     # #    #  ####     #    #    # #    #   #  "
echo "-------------------------------------------------"
echo "14/12/2016"
echo "version: 1.0"
echo "-------------------------------------------------"

# RasPi config (PUT this to external script)
#echo "Please extend filesystem and enable camera & ssh; set GPU to 400mb"
#sudo raspi-config
#sudo reboot

# Remove unnecessary packages (wolfram, etc) and clean up
echo "Removing unnecessary packages and cleaning up."
sudo apt-get purge wolfram-engine sonic-pi scratch nuscratch smartsim penguinspuzzle minecraft-pi python-minecraftpi python3-minecraftpi 
sudo apt-get remove --purge libreoffice*
sudo apt-get remove libopencv*
sudo apt-get clean
sudo apt-get autoremove
rm /home/pi/python_games/*
rmdir /home/pi/python_games/
echo "Done."

# Initial preparation
echo "Update package repository information."
sudo apt-get update
sudo apt-get upgrade
sudo easy_install -U distribute
echo "Done."

# Install CMake
echo "Installing CMake."
sudo apt-get install build-essential cmake pkg-config git
echo "Done."

# Install gcc 6.1 & fortran
#echo "Installing gcc 6.1 and fortran compiler."
#sudo perl -pi -e 's/jessie/stretch/g' /etc/apt/sources.list
#sudo apt-get update
#sudo apt-get install gcc-6 g++-6
#sudo apt-get install gfortran-6
#sudo perl -pi -e 's/stretch/jessie/g' /etc/apt/sources.list
#sudo apt-get update
#echo "Done."

# Install Python
echo "Installing Python 2 and 3, including supporting packages."
sudo apt-get install python  python-dev python3 python3-dev # probably not required
sudo apt-get install python-setuptools python-pip python3-pip
sudo apt-get install ipython
sudo pip install numpy scipy matplotlib
sudo pip3 install numpy scipy matplotlib
sudo pip install https://github.com/sightmachine/SimpleCV/zipball/master
sudo pip install svgwrite
echo "Done."

# Install Image I/O's
echo "Installing multimedia packages, including ffmpeg."
sudo apt-get install libjpeg-dev libfreetype6-dev libtiff5-dev libjasper-dev libpng12-dev
# Install Video I/O's
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libeigen3-dev
# Install ffmpeg
sudo apt-get install libmp3lame-dev libopus-dev autoconf libtool checkinstall libssl-dev
# build and install x264
git clone --depth 1 git://git.videolan.org/x264
cd x264
./configure --host=arm-unknown-linux-gnueabi --enable-static --disable-opencl --enable-shared
make -j4 && echo OK || echo Failed
sudo make install
# build and make ffmpeg
git clone --depth=1 git://source.ffmpeg.org/ffmpeg.git
cd ffmpeg
./configure --arch=armel --target-os=linux --enable-gpl --enable-libx264 --enable-nonfree  --enable-shared
make -j4 && echo OK || echo Failed
sudo make install
# Install GTK (might need aptitude for this)
sudo apt-get install libgtk2.0-dev && echo OK || echo Failed
# Install others
sudo apt-get install libatlas-base-dev gfortran
echo "Done."

# Enable kernel
echo "Enabling kernel."
sudo modprobe bcm2835-v4l2
v4l2-ctl --list-devices
echo "Done."

# Install OpenCV 3.1
echo "Installing OpenCV 3.1."
cd ~
wget -O opencv.zip https://github.com/Itseez/opencv/archive/3.1.0.zip && echo OK || echo Failed
wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.1.0.zip && echo OK || echo Failed
unzip opencv_contrib.zip
unzip opencv.zip
#build
cd ~/opencv-3.1.0/
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D BUILD_WITH_DEBUG_INFO=OFF \
	-D BUILD_DOCS=OFF \
	-D BUILD_EXAMPLES=OFF \
	-D BUILD_TESTS=OFF \
	-D BUILD_opencv_ts=OFF \
	-D BUILD_PERF_TESTS=OFF \
	-D INSTALL_C_EXAMPLES=OFF \
	-D INSTALL_PYTHON_EXAMPLES=ON \
	-D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-3.1.0/modules \
	-D ENABLE_NEON=ON \
	-D WITH_LIBV4L=ON \
        ../
make -j4 && echo OK || echo Failed
sudo make install
sudo ldconfig
echo "Done."
echo "-------------------------------------------------"
echo "RasTart done."
echo "-------------------------------------------------"