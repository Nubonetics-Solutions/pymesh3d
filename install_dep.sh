apt-get update && apt-get install -y \
    gcc \
    g++ \
    git \
    libeigen3-dev \
    libgmp-dev \
    libmpfr-dev \
    libgmpxx4ldbl \
    libboost-dev \
    libboost-thread-dev \
    libtbb-dev \
    python3-dev \
    python3-setuptools \
	  python3-numpy \
	  python3-scipy \
	  python3-nose \
	  python3-pip \
    wget && \
    apt-get clean

mkdir /tmp/cmake
cd /tmp/cmake

wget https://github.com/Kitware/CMake/releases/download/v3.13.4/cmake-3.13.4.tar.gz && \
    tar -xzvf cmake-3.13.4.tar.gz > /dev/null

cd cmake-3.13.4

./bootstrap > /dev/null && \
    make -j$(nproc --all) > /dev/null && \
    make install > /dev/null
    
rm -rf /tmp/cmake
