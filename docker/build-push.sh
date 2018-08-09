#!/bin/bash
./build.sh $1
docker push councilbox/alastria
docker push councilbox/alastria:v$1
