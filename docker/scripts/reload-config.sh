#!/bin/bash

# Reloads Alastria Access Point configuration

if [ -z "$1" ]; then
        echo "$0: insufficient arguments, missing PROXY"
        echo "Usage: ./reload-config.sh PROXY"
        exit
fi

if [ $1 = "nginx" ]; then
        DOCKER_ID=$(docker ps -aqf "name=Telsius")
        docker exec "$DOCKER_ID" nginx -s reload
fi
