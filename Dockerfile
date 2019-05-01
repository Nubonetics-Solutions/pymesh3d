FROM pymesh/pymesh:latest
MAINTAINER Behzad Samadi bsamadi@nubonetics.com

# metadata
LABEL version="0.1"
LABEL description="Pymesh"

RUN apt-get update && \
    apt-get install libc6 && \
    pip install jupyter
