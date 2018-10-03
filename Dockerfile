FROM ubuntu:16.04

LABEL maintainer "Alfonso de la Rocha (https://github.com/arochaga)"

ARG hostip
ARG nodetype
ARG nodename
ENV HOST_IP $hostip

COPY data /root/alastria-node/data
RUN chmod -R u+x /root/alastria-node/data

COPY scripts /root/alastria-node/scripts
RUN chmod -R u+x /root/alastria-node/scripts

WORKDIR /root/alastria-node/scripts

RUN apt-get update && apt-get upgrade -y && apt-get install -y sudo curl cron nano
RUN ./bootstrap.sh
RUN ./init.sh dockerfile $nodetype $nodename
RUN ./monitor.sh build

EXPOSE 9000 21000 21000/udp 22000 41000 8443

CMD ["/root/alastria-node/scripts/start.sh","--watch"]
