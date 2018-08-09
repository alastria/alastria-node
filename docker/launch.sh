#!/bin/bash
DATA_DIR="$(cat DATA_DIR 2> /dev/null)"
WORK_DIR="$(pwd)"/alastria
DATA_DIR=${DATA_DIR:-$WORK_DIR}

NODE_NAME="$(cat NODE_NAME 2> /dev/null)"
NODE_NAME=${NODE_NAME:-REG_UNNAMED_TestNet_2_4_00}

NODE_TYPE="$(cat NODE_TYPE 2> /dev/null)"
NODE_TYPE=${NODE_TYPE:-general}

docker run -tid \
-v $DATA_DIR:/root/alastria \
-p 21000:21000 \
-p 21000:21000/udp \
-p 22000:22000 \
-p 9000:9000 \
-p 8443:8443 \
--restart unless-stopped \
--name $NODE_NAME \
councilbox/alastria $NODE_TYPE $NODE_NAME
