#!/bin/bash
NODE_NAME="$(cat NODE_NAME 2> /dev/null)"
NODE_NAME=${NODE_NAME:-REG_UNNAMED_TestNet_2_4_00}
docker exec -ti $NODE_NAME bash -c "cd /opt/alastria-node/scripts && ./stop.sh && ./monitor.sh stop"
docker stop $NODE_NAME
