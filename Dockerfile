FROM bravostuzero/tango-cpp

USER root

RUN apt-get update && apt-get install -y python-pip pkg-config libboost-python-dev

RUN pip install numpy pytango==9.2.5 pyepics

RUN mkdir -p /home/tango

WORKDIR /home/tango

USER tango

COPY ./TangoEpics/release_1_0 ./TangoEpics

FROM dmscid/epics-base