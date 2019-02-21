# Alastria Node
# Copyright (C) 2019 Guillermo Araujo Riestra <guillermo.araujo@babel.es>
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
################################################
# ALASTRIA NODE
################################################

ARG DOCKER_VERSION=latest
ARG ALASTRIA_BRANCH=feature/testnet2-docker

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
    && cd /root \
    && git clone -b $ALASTRIA_BRANCH https://github.com/go2chain/alastria-node \
    && cd alastria-node/scripts \
    && sed -i 's/sudo//g' bootstrap.sh \
    && sed -i 's/gopath$//' bootstrap.sh \
    # && sed -i 's@~/alastria-node@/opt/alastria-node@g' init.sh \
    # && sed -i 's@~/alastria-node@/opt/alastria-node@g' restart.sh \
    # && sed -i 's@~/alastria-node@/opt/alastria-node@g' update.sh \
    # && sed -i 's@~/alastria-node@/opt/alastria-node@g' updatePerm.sh \
    && ./bootstrap.sh \
    && ./monitor.sh build \
    && apt-get autoremove \
    && apt-get clean

VOLUME /root/alastria
EXPOSE 21000 21000/udp 8443

COPY entrypoint.sh /usr/bin/
WORKDIR /root/alastria-node/scripts
ENTRYPOINT ["entrypoint.sh"]
CMD ["validator", "Unknown"]