FROM pymesh/pymesh
MAINTAINER Behzad Samadi bsamadi@nubonetics.com

# metadata
LABEL version="0.1"
LABEL description="Pymesh"

RUN apt-get update && \
    pip install pymesh
