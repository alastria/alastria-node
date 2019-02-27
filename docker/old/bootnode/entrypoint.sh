#!/bin/bash
NODE_TYPE=$1
NODE_NAME=$2

if [ ! -f ~/alastria/data/IDENTITY ]; then
    ./init.sh auto $NODE_TYPE $NODE_NAME
    if [[ "$NODE_TYPE" == "validator" ]]; then
        ./monitor.sh start
    fi
elif [ ! -f ~/alastria/data/DOCKER_VERSION_$DOCKER_VERSION ]; then
    echo "[*] Updating static-nodes"
    cp /opt/alastria-node/data/static-nodes.json ~/alastria/data/static-nodes.json
    echo "[*] Updating permissioned-nodes"
    cp /opt/alastria-node/data/permissioned-nodes_$NODE_TYPE.json ~/alastria/data/permissioned-nodes.json
    rm -f ~/alastria/data/DOCKER_VERSION_* 2> /dev/null
    touch ~/alastria/data/DOCKER_VERSION_$DOCKER_VERSION
fi

exec ./start.sh --watch
