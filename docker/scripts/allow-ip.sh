#!/bin/bash

# Adds IP address to nginx whitelist

if [ -z "$1" ]; then
        echo "$0: insufficient arguments"
        echo "Usage: ./allow-ip.sh PROXY [ -r ] IP_ADDRESS_0 [ IP_ADDRESS_1 [ IP_ADDRESS_N ] ]"
        exit
fi

if [ $1 = "nginx" ]; then
        DIRECTORY="../config"
        NODE_NAME=$(head -n 1 "$DIRECTORY"/NODE_NAME 2> /dev/null)
        if [ $2 = "-r" ]; then
                for IP in "${@:3}"
                do
                        docker exec $NODE_NAME bash -c "sed -i '/$IP/d' /etc/nginx/whitelist"
                done
        else
                for IP in "${@:2}"
                do
                        docker exec $NODE_NAME bash -c "echo \"allow $IP;\" >> /etc/nginx/whitelist"
                done
        fi
        docker exec "$NODE_NAME" nginx -s reload
fi
