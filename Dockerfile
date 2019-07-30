FROM lnlssol/debian9-epicsbase as epics

FROM bravostuzero/tango-cpp

USER root

COPY --from=epics /usr/local/epics /usr/local/epics

COPY --from=epics /etc/profile.d/epics.sh /etc/profile.d/01-epics.sh

COPY --from=epics /etc/ld.so.conf.d/epics.conf /etc/ld.so.conf.d/epics.conf

RUN apt-get update && apt-get install -y net-tools supervisor python-pip pkg-config libboost-python-dev

#required for epics env variables script
RUN ln -s /sbin/ifconfig /usr/bin/ifconfig

RUN pip install numpy pyepics pytango==9.2.5

COPY supervisord.conf /etc/supervisor/conf.d/
COPY tango_register_device /usr/local/bin
COPY ./TangoEpics/release_1_0 /usr/local/bin

RUN chmod +x /usr/local/bin/TangoEpics

ENV TANGO_HOST hzgxenvtest.desy.de:10000

CMD ["/usr/bin/supervisord", "--configuration", "/etc/supervisor/supervisord.conf"]