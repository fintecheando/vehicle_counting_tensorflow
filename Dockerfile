# Use an official Python runtime as a parent image
FROM ubuntu:16.04
RUN apt-get update
RUN apt-get upgrade -y

#Install Python Dev
# for Python 2.7
RUN apt-get install -y python-pip python-dev   
# for Python 3.n
#RUN sudo apt-get install python3-pip python3-dev 

# install dependencies
RUN apt-get install -y build-essential
RUN apt-get install -y cmake
RUN apt-get install -y libgtk2.0-dev
RUN apt-get install -y pkg-config
RUN apt-get install -y python-numpy python-dev
RUN apt-get install -y libavcodec-dev libavformat-dev libswscale-dev
RUN apt-get install -y libjpeg-dev libpng-dev libtiff-dev libjasper-dev
 
RUN apt-get -qq install wget libopencv-dev build-essential checkinstall cmake pkg-config yasm libjpeg-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libxine2-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev python-dev python-numpy libtbb-dev libqt4-dev libgtk2.0-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils
 
# download opencv-2.4.11
RUN wget http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/2.4.11/opencv-2.4.11.zip
RUN unzip opencv-2.4.11.zip
RUN cd opencv-2.4.11
RUN mkdir release
RUN cd release
 
# compile and install
RUN cmake -G "Unix Makefiles" -D CMAKE_CXX_COMPILER=/usr/bin/g++ CMAKE_C_COMPILER=/usr/bin/gcc -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D WITH_QT=ON -D WITH_OPENGL=ON -D BUILD_FAT_JAVA_LIB=ON -D INSTALL_TO_MANGLED_PATHS=ON -D INSTALL_CREATE_DISTRIB=ON -D INSTALL_TESTS=ON -D ENABLE_FAST_MATH=ON -D WITH_IMAGEIO=ON -D BUILD_SHARED_LIBS=OFF -D WITH_GSTREAMER=ON ..
RUN make all -j4 # 4 cores
RUN make install
 
# ignore libdc1394 error http://stackoverflow.com/questions/12689304/ctypes-error-libdc1394-error-failed-to-initialize-libdc1394
 
#python
#> import cv2
#> cv2.SIFT
#<built-in function SIFT>

#Install TensorFlow
#RUN pip install tensorflow      # Python 2.7; CPU support (no GPU support)
#RUN pip3 install tensorflow     # Python 3.n; CPU support (no GPU support)
#RUN pip install tensorflow-gpu  # Python 2.7;  GPU support
# Python 3.n; GPU support
RUN pip3 install tensorflow-gpu 

RUN apt-get install protobuf-compiler python-pil python-lxml python-tk
RUN pip install jupyter
RUN pip install matplotlib
RUN pip install pillow
RUN pip install lxml
RUN pip install jupyter
RUN pip install matplotlib

#COCO API installation
RUN git clone https://github.com/cocodataset/cocoapi.git
RUN cd cocoapi/PythonAPI
RUN make
RUN cp -r pycocotools <path_to_tensorflow>/models/research/

#Protobuf Compilation
# From tensorflow/models/research/
RUN protoc object_detection/protos/*.proto --python_out=.

#Add Libraries to PYTHONPATH
# From tensorflow/models/research/
RUN export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim

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
