FROM ubuntu:bionic
MAINTAINER Behzad Samadi bsamadi@nubonetics.com

# metadata
LABEL version="0.1"
LABEL description="Pymesh"
ARG BRANCH="master"
ARG NUM_CORES=2
WORKDIR /root/
COPY install_dep.sh /root/
RUN chmod +x install_dep.sh && ./install_dep.sh

WORKDIR /root/
RUN git clone --single-branch -b $BRANCH https://github.com/PyMesh/PyMesh.git  && \
    pip3 install jupyter ptvsd
    
ENV PYMESH_PATH /root/PyMesh
ENV NUM_CORES $NUM_CORES
WORKDIR $PYMESH_PATH

RUN git submodule update --init && \
    pip3 install -r $PYMESH_PATH/python/requirements.txt && \
    mkdir build
    
WORKDIR $PYMESH_PATH/third_party

RUN mkdir build

WORKDIR $PYMESH_PATH/third_party/build

RUN cmake .. && \
    make && \
    make install

WORKDIR $PYMESH_PATH/build

RUN cmake .. && \
    make && \
    make test

WORKDIR $PYMESH_PATH

RUN python3 setup.py install && \
    rm -rf build third_party/build && \
    python3 -c "import pymesh; pymesh.test()" && \
    python3 $PYMESH_PATH/docker/patches/patch_wheel.py
