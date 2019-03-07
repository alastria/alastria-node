#!/bin/bash

# Reloads Alastria Access Point configuration

if [ -z "$1" ]; then
        echo "$0: insufficient arguments, missing PROXY"
        echo "Usage: ./reload-config.sh PROXY"
        exit
fi

if [ $1 = "nginx" ]; then
        DIRECTORY="../config"
        NODE_NAME=$(head -n 1 "$DIRECTORY"/NODE_NAME 2> /dev/null)
        docker exec "$NODE_NAME" nginx -s reload
fi
