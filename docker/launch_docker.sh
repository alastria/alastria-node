#!/bin/bash
DATA_DIR=$(head -n 1 DATA_DIR 2> /dev/null)
WORK_DIR="$(pwd)"/alastria
DATA_DIR=${DATA_DIR:-$WORK_DIR}

NODE_NAME=$(head -n 1 NODE_NAME 2> /dev/null)

if ( [ -z "$NODE_NAME" ] )
then
  echo "Error: File NODE_NAME empty. You must have a node name, please contact with support@alastria.io"
  exit
fi

NODE_TYPE=$(head -n 1 NODE_TYPE 2> /dev/null)

if ( [ -z "$NODE_TYPE" ] )
then
  echo "Error: File NODE_TYPE empty. You must have a node type, please contact with support@alastria.io"
  exit
fi

MONITOR_ENABLED=$(head -n 1 MONITOR_ENABLED 2> /dev/null)

if ( [ -z "$MONITOR_ENABLED" ] )
then
  echo "Error: File MONITOR_ENABLED empty. You must have a monitor_enabled var, please contact with support@alastria.io"
  exit
fi

docker run -tid \
-v $DATA_DIR:/root/alastria \
-p 21000:21000 \
-p 21000:21000/udp \
-p 22000:22000 \
-p 9000:9000 \
-p 8443:8443 \
--restart unless-stopped \
--name $NODE_NAME \
-e NODE_TYPE=$NODE_TYPE \
-e NODE_NAME=$NODE_NAME \
-e MONITOR_ENABLED=$MONITOR_ENABLED \
$@ \
alastria-node