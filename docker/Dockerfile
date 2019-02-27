# Alastria Node
# Copyright (C) 2019 Alastria <support@alastria.io>
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
ARG ALASTRIA_BRANCH=testnet2

ENV \
    DOCKER_VERSION=$DOCKER_VERSION

RUN \
    apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install \
        git \
        curl \
        dnsutils \
    && cd \
    && git clone -b $ALASTRIA_BRANCH https://github.com/alastria/alastria-node \
    && cd alastria-node/scripts \
    && sed -i 's/sudo//g' bootstrap.sh \
    && ./bootstrap.sh \
    && ./monitor.sh build \
    && apt-get autoremove \
    && apt-get clean

VOLUME /root/alastria
EXPOSE 9000 21000 21000/udp 22000 8443

COPY entrypoint.sh /usr/bin/
WORKDIR /root/alastria-node/scripts
ENTRYPOINT ["entrypoint.sh"]
CMD