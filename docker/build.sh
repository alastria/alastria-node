#!/bin/bash
docker build --build-arg DOCKER_VERSION=$1 -t councilbox/alastria .
docker tag councilbox/alastria councilbox/alastria:v$1
