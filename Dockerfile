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
    apt-get purge -y cmake
    
WORKDIR /tmp/cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.13.4/cmake-3.13.4.tar.gz && \
    tar -xzvf cmake-3.13.4.tar.gz > /dev/null

WORKDIR cmake-3.13.4
RUN ./bootstrap > /dev/null && \
    make -j$(nproc --all) > /dev/null && \
    make install > /dev/null

WORKDIR /root/
RUN rm -rf /tmp/cmake && \
    git clone --single-branch -b $BRANCH https://github.com/PyMesh/PyMesh.git  && \
    pip install jupyter ptvsd && \
    wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && \
    apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && \
    wget https://apt.repos.intel.com/setup/intelproducts.list -O /etc/apt/sources.list.d/intelproducts.list && \
    sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list'

RUN apt-get update && \
    apt-get install intel-mkl
    
ENV PYMESH_PATH /root/PyMesh
ENV NUM_CORES $NUM_CORES
WORKDIR $PYMESH_PATH

RUN git submodule update --init && \
    pip install -r $PYMESH_PATH/python/requirements.txt && \
    mkdir build
    
WORKDIR $PYMESH_PATH/build

RUN cmake .. && \
    make && \
    make tools

WORKDIR $PYMESH_PATH

RUN rm -rf build third_party/build && \
    python -c "import pymesh; pymesh.test()" && \
    python $PYMESH_PATH/docker/patches/patch_wheel.py
