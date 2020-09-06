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
ARG GITHUB_USER=alastria

ENV \
    DOCKER_VERSION=$DOCKER_VERSION

RUN \
    apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install \
        git \
        curl \
        dnsutils \
        net-tools \
        nginx \
        nginx-extras \
        nano \
    && rm -Rf /etc/nginx/sites-enabled/default \
    && rm -Rf /etc/nginx/sites-available/default \
    && apt-get autoremove \
    && apt-get clean

# Prevent Docker from caching git clone
ADD https://api.github.com/repos/$GITHUB_USER/alastria-node/git/refs/heads/$ALASTRIA_BRANCH version.json
RUN \
    cd \
    && git clone -b $ALASTRIA_BRANCH https://github.com/$GITHUB_USER/alastria-node 

VOLUME /root/alastria
VOLUME /etc/nginx/conf.d
EXPOSE 9000 21000 21000/udp 22000 8443 80 443 9090

COPY entrypoint.sh /usr/bin/

WORKDIR /root/alastria-node
ENTRYPOINT ["entrypoint.sh"]
CMD
