# Alastria docker
# Copyright 2018 Councilbox Technology, S.L., Rodrigo Martínez Castaño
#
# This product includes software developed at
# Councilbox Technology, S.L. (https://www.councilbox.com/)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:16.04

################################################
# ALASTRIA DOCKER
################################################

ARG ALASTRIA_BRANCH=develop
ARG DOCKER_VERSION=latest

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
    && ./bootstrap.sh

ARG MONITOR_ENABLED=0
ENV \
    GOROOT=/usr/local/go \
    GOPATH=/opt/golang \
    PATH=/usr/local/go/bin:/opt/golang/bin:$PATH \
    MONITOR_ENABLED=$MONITOR_ENABLED \
    DOCKER_VERSION=$DOCKER_VERSION

WORKDIR /opt/alastria-node/scripts
RUN \
    if [ $MONITOR_ENABLED -eq 1 ]; then ./monitor.sh build; fi \
    && apt-get autoremove \
    && apt-get clean

VOLUME /root/alastria
EXPOSE 9000 21000 21000/udp 22000 8443

COPY entrypoint.sh /usr/bin/
ENTRYPOINT ["entrypoint.sh"]
