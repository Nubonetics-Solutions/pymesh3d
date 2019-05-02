FROM python:3.6
MAINTAINER Behzad Samadi bsamadi@nubonetics.com

# metadata
LABEL version="0.1"
LABEL description="Pymesh"
ARG BRANCH="master"
ARG NUM_CORES=2
WORKDIR /root/

RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    git \
    cmake \
    libgmp-dev \
    libmpfr-dev \
    libgmpxx4ldbl \
    libboost-dev \
    libboost-thread-dev && \
    apt-get clean && \
    git clone --single-branch -b $BRANCH https://github.com/PyMesh/PyMesh.git
    
RUN pip install jupyter ptvsd
    
ENV PYMESH_PATH /root/PyMesh
ENV NUM_CORES $NUM_CORES
WORKDIR $PYMESH_PATH

RUN git submodule update --init && \
    pip install -r $PYMESH_PATH/python/requirements.txt && \
    ./setup.py bdist_wheel && \
    rm -rf build third_party/build && \
    pip install dist/pymesh2*.whl && \
    python -c "import pymesh; pymesh.test()" && \
    python $PYMESH_PATH/docker/patches/patch_wheel.py
