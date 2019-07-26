FROM dmscid/epics-base as epics

FROM bravostuzero/tango-cpp

USER root

COPY --from=epics /EPICS /EPICS

COPY --from=epics /etc/profile.d/01-epics-base.sh /etc/profile.d

RUN apt-get update && apt-get install -y net-tools supervisor python-pip pkg-config libboost-python-dev

COPY supervisord.conf /etc/supervisor/conf.d/

#required for epics env variables script
RUN ln -s /sbin/ifconfig /usr/bin/ifconfig

RUN pip install numpy pyepics pytango==9.2.5

RUN mkdir -p /home/tango

COPY ./TangoEpics/release_1_0 /home/tango

ENV TANGO_HOST hzgxenvtest.desy.de:10000

CMD ["/usr/bin/supervisord", "--configuration", "/etc/supervisor/supervisord.conf"]