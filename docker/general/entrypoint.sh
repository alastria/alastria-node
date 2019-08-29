#!/bin/bash

_term() {
    pkill -f geth
    wait
}

trap _term SIGTERM

git pull
cd ./scripts
sed -i 's/sudo//g' bootstrap.sh
./bootstrap.sh

if [ ! -f ~/alastria/data/IDENTITY ]; then
    ./init.sh auto $NODE_TYPE $NODE_NAME
elif [ ! -f ~/alastria/data/DOCKER_VERSION_$DOCKER_VERSION ]; then
    echo "[*] Updating static-nodes and permissioned-nodes"
    ./updatePerm.sh $NODE_TYPE
    rm -f ~/alastria/data/DOCKER_VERSION_* 2> /dev/null
    touch ~/alastria/data/DOCKER_VERSION_$DOCKER_VERSION
fi

/etc/init.d/nginx start
nginx -g "daemon off;"
ARGS="--watch --local-rpc --no-monitor"
if [ ! $MONITOR_ENABLED -eq 0 ]; then
    ./monitor.sh build
    ARGS="--watch --local-rpc"
fi
exec ./start.sh $ARGS &

child=$!
wait "$child"
