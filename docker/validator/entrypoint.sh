#!/bin/bash

if [ ! -f ~/alastria/data/IDENTITY ]; then
    ./init.sh auto $NODE_TYPE $NODE_NAME
# elif [ ! -f ~/alastria/data/DOCKER_VERSION_$DOCKER_VERSION ]; then
#     echo "[*] Updating static-nodes"
#     cp $HOME/alastria-node/data/static-nodes.json ~/alastria/data/static-nodes.json
#     echo "[*] Updating permissioned-nodes"
#     cp $HOME/alastria-node/data/permissioned-nodes_$NODE_TYPE.json ~/alastria/data/permissioned-nodes.json
#     rm -f ~/alastria/data/DOCKER_VERSION_* 2> /dev/null
#     touch ~/alastria/data/DOCKER_VERSION_$DOCKER_VERSION
fi

exec ENABLE_CONSTELLATION=$ENABLE_CONSTELLATION && ./start.sh $ARGS