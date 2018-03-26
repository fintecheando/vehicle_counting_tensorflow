# Use an official Python runtime as a parent image
FROM ubuntu:16.04
RUN apt-get update
RUN apt-get upgrade -y

#Install Python Dev
# for Python 2.7
RUN apt-get install -y python-pip python-dev   
# for Python 3.n
#RUN apt-get install -y python3-pip python3-dev 

# install dependencies
RUN apt-get install -y build-essential
RUN apt-get install -y cmake
RUN apt-get install -y libgtk2.0-dev
RUN apt-get install -y pkg-config
RUN apt-get install -y python-numpy python-dev
RUN apt-get install -y libavcodec-dev libavformat-dev libswscale-dev
RUN apt-get install -y libjpeg-dev libpng-dev libtiff-dev libjasper-dev
 
RUN apt-get -qq install libopencv-dev build-essential checkinstall cmake pkg-config yasm libjpeg-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libxine2-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev python-dev python-numpy libtbb-dev libqt4-dev libgtk2.0-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils
 
#example taken from https://github.com/Quanticare/docker-opencv/blob/master/Dockerfile
 
RUN apt-get update && apt-get install -y cmake ninja-build wget unzip gcc g++ gstreamer1.0-libav libgstreamer1.0-dev libgstreamer-plugins-bad1.0-dev libgstreamer-plugins-good1.0-dev libgstreamer-plugins-base1.0-dev libpython-dev python-numpy libboost-all-dev libcurl4-openssl-dev gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-tools && \
  wget --quiet http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/2.4.11/opencv-2.4.11.zip && \
  unzip opencv-2.4.11.zip && \
  cd opencv-2.4.11/ && \
  mkdir build && cd build && \
  cmake .. -DWITH_FFMPEG=OFF -DWITH_GSTREAMER=ON -DWITH_OPENMP=ON -DBUILD_DOCS=OFF -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_EXAMPLES=OFF -DWITH_QT=OFF -DWITH_GTK=OFF -DWITH_OPENGL=OFF -DWITH_VTK=OFF -DWITH_1394=ON -GNinja -DCMAKE_INSTALL_PREFIX=/.opencv-install/ && \
  ninja install && \
  wget --quiet https://github.com/google/glog/archive/v0.3.3.zip && unzip v0.3.3.zip && \
  cd glog-0.3.3/ && ./configure --prefix=/usr && make install -j8 && \
  cd / && rm -rf 2.4.11.zip opencv-2.4.11/ glog-0.3.3/ v0.3.3.zip && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

 
# ignore libdc1394 error http://stackoverflow.com/questions/12689304/ctypes-error-libdc1394-error-failed-to-initialize-libdc1394
 
#python
#> import cv2
#> cv2.SIFT
#<built-in function SIFT>

#Install TensorFlow
RUN apt-get remove -y python-pip 
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
#RUN python3 get-pip.py
# Python 2.7; CPU support (no GPU support)
#RUN pip install --upgrade pip && pip install --default-timeout=100 tensorflow 
# Python 3.n; CPU support (no GPU support)     
#RUN pip3 install tensorflow     
# Python 2.7;  GPU support
RUN pip install --upgrade pip && pip install --default-timeout=100 tensorflow-gpu 

# Python 3.n; GPU support
#RUN pip3 install tensorflow-gpu 

#RUN apt-get install protobuf-compiler python-pil python-lxml python-tk
RUN pip install jupyter
RUN pip install matplotlib
RUN pip install pillow
RUN pip install lxml
RUN pip install jupyter
RUN pip install matplotlib
RUN pip install opencv-python

#Protobuf Compilation
# From tensorflow/models/research/
# Make sure you grab the latest version
RUN curl -OL https://github.com/google/protobuf/releases/download/v3.3.0/protoc-3.3.0-linux-x86_64.zip

# Unzip
RUN unzip protoc-3.3.0-linux-x86_64.zip -d protoc3

# Move protoc to /usr/local/bin/
RUN mv protoc3/bin/* /usr/local/bin/

# Move protoc3/include to /usr/local/include/
RUN mv protoc3/include/* /usr/local/include/

RUN apt-get update
RUN apt-get install -y python-tk python-scipy
#RUN protoc object_detection/protos/*.proto --python_out=.

#Add Libraries to PYTHONPATH
# From tensorflow/models/research/
#RUN export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim

#Testing the Installation
#RUN python object_detection/builders/model_builder_test.py



# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Make port 80 available to the world outside this container
#EXPOSE 80

# Define environment variable
#ENV NAME World

# Run app.py when the container launches
CMD ["python", "vehicle_detection_main.py"]
