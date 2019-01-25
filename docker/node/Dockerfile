# Alastria Node
# Copyright (C) 2018 Rodrigo Martínez <rodrigo.martinez@councilbox.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

FROM ubuntu:16.04
MAINTAINER "Rodrigo Martínez" <rodrigo.martinez@councilbox.com>

################################################
# ALASTRIA NODE
################################################

ARG DOCKER_VERSION=latest
ARG ALASTRIA_BRANCH=develop

ENV \
    GOROOT=/usr/local/go \
    GOPATH=/opt/golang \
    PATH=/usr/local/go/bin:/opt/golang/bin:$PATH \
    DOCKER_VERSION=$DOCKER_VERSION

RUN \
    apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install \
        git \
        curl \
    && cd /opt \
    && git clone -b $ALASTRIA_BRANCH https://github.com/alastria/alastria-node \
    && cd alastria-node/scripts \
    && sed -i 's/sudo//g' bootstrap.sh \
    && sed -i 's/gopath$//' bootstrap.sh \
    && sed -i 's@~/alastria-node@/opt/alastria-node@g' init.sh \
    && sed -i 's@~/alastria-node@/opt/alastria-node@g' restart.sh \
    && sed -i 's@~/alastria-node@/opt/alastria-node@g' update.sh \
    && ./bootstrap.sh \
    && ./monitor.sh build \
    && apt-get autoremove \
    && apt-get clean

VOLUME /root/alastria
EXPOSE 9000 21000 21000/udp 22000 8443

COPY entrypoint.sh /usr/bin/
WORKDIR /opt/alastria-node/scripts
ENTRYPOINT ["entrypoint.sh"]
CMD ["general"]