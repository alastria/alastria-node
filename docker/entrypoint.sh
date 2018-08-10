#!/bin/bash
if [ -z "$NODE_TYPE" ]; then
    echo "NODE_TYPE unset. Exiting..."
    exit
elif [ "$NODE_TYPE" != "general" -a "$NODE_TYPE" != "validator" ]; then
    echo "Invalid NODE_TYPE. Exiting..."
    exit
fi
if [ -z "$NODE_NAME" ]; then
    echo "NODE_NAME unset. Exiting..."
    exit
fi

if [ ! -f ~/alastria/data/IDENTITY ]; then
    ./init.sh auto $NODE_TYPE $NODE_NAME
elif [ ! -f ~/alastria/data/DOCKER_VERSION_$DOCKER_VERSION ]; then
    echo "[*] Updating static-nodes"
    cp /opt/alastria-node/data/static-nodes.json ~/alastria/data/static-nodes.json
    echo "[*] Updating permissioned-nodes"
    cp /opt/alastria-node/data/permissioned-nodes_$NODE_TYPE.json ~/alastria/data/permissioned-nodes.json
    rm -f ~/alastria/data/DOCKER_VERSION_* 2> /dev/null
    touch ~/alastria/data/DOCKER_VERSION_$DOCKER_VERSION
fi

if [ $MONITOR_ENABLED -eq 1 ]; then
    ./monitor.sh start
fi

exec ./start.sh --watch
