FROM ubuntu:xenial

LABEL maintainer "Jakub Vanak (https://github.com/Koubek)"

COPY data /root/alastria-node/data
RUN chmod -R u+x /root/alastria-node/data

COPY scripts /root/alastria-node/scripts
RUN chmod -R u+x /root/alastria-node/scripts

WORKDIR /root/alastria-node/scripts

RUN sed -i -e 's/\r$//' init.sh && sed -i -e 's/\r$//' bootstrap.sh && sed -i -e 's/\r$//' start.sh

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -q -y curl \
  libcurl3 unzip wget git make gcc libsodium-dev build-essential libdb-dev zlib1g-dev libtinfo-dev sysvbanner wrk psmisc

WORKDIR /root/alastria-node/scripts
RUN ./bootstrap.sh

EXPOSE 9000 21000 21000/udp 22000 41000

# CMD ["/run.sh"]
