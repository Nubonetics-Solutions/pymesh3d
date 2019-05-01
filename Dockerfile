FROM pymesh/pymesh:py3.6
MAINTAINER Behzad Samadi bsamadi@nubonetics.com

# metadata
LABEL version="0.1"
LABEL description="Pymesh"

RUN pip install jupyter
