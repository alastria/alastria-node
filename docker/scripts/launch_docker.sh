#!/bin/bash
DIRECTORY="../config"
DATA_DIR=$(head -n 1 $DIRECTORY/DATA_DIR 2> /dev/null)
WORK_DIR="$(pwd)"/alastria
DATA_DIR=${DATA_DIR:-$WORK_DIR}

NODE_NAME=$(head -n 1 $DIRECTORY/NODE_NAME 2> /dev/null)

if ( [ -z "$NODE_NAME" ] )
then
  echo "Error: File NODE_NAME empty. You must have a node name, please contact with support@alastria.io"
  exit
fi

NODE_TYPE=$(head -n 1 $DIRECTORY/NODE_TYPE 2> /dev/null)

if ( [ -z "$NODE_TYPE" ] )
then
  echo "Error: File NODE_TYPE empty. You must have a node type, please contact with support@alastria.io"
  exit
fi

MONITOR_ENABLED=$(head -n 1 $DIRECTORY/MONITOR_ENABLED 2> /dev/null)

if ( [ -z "$MONITOR_ENABLED" ] )
then
  echo "Error: File MONITOR_ENABLED empty. You must have a monitor_enabled var, please contact with support@alastria.io"
  exit
fi

if [ "$NODE_TYPE" == "bootnode" ]; then
   docker run --name $NODE_NAME -v $DATA_DIR:/root/alastria -p 21000:21000 -p 21000:21000/udp -p 8443:8443  -e NODE_TYPE=$NODE_TYPE -e NODE_NAME=$NODE_NAME -e MONITOR_ENABLED=$MONITOR_ENABLED --restart unless-stopped alastria-node-bootnode
 else
   if [ "$NODE_TYPE" == "validator" ]; then
    docker run --name $NODE_NAME -v $DATA_DIR:/root/alastria -p 21000:21000 -p 21000:21000/udp -p 8443:8443 -p 127.0.0.1:22000:22000 -e NODE_TYPE=$NODE_TYPE -e NODE_NAME=$NODE_NAME -e MONITOR_ENABLED=$MONITOR_ENABLED --restart unless-stopped alastria-node-validator
 else
   if [ "$NODE_TYPE" == "general" ]; then
    if [ $MONITOR_ENABLED -eq 1 ]; then
      docker run --name $NODE_NAME -v $DATA_DIR:/root/alastria -p 22000:22000 -p 21000:21000 -p 21000:21000/udp -p 9000:9000 -p 8443:8443 -e NODE_TYPE=$NODE_TYPE -e NODE_NAME=$NODE_NAME -e MONITOR_ENABLED=$MONITOR_ENABLED -e ENABLE_CONSTELLATION=$ENABLE_CONSTELLATION --restart unless-stopped alastria-node-general
    else
      docker run --name $NODE_NAME -v $DATA_DIR:/root/alastria -p 22000:22000 -p 21000:21000 -p 21000:21000/udp -p 9000:9000 -e NODE_TYPE=$NODE_TYPE -e NODE_NAME=$NODE_NAME -e MONITOR_ENABLED=$MONITOR_ENABLED -e ENABLE_CONSTELLATION=$ENABLE_CONSTELLATION --restart unless-stopped alastria-node-general
    fi
  fi
  fi
fi