#!/bin/bash
DIRECTORY="../config"
NODE_TYPE=$(head -n 1 $DIRECTORY/NODE_TYPE 2> /dev/null)

if ( [ -z "$NODE_TYPE" ] )
then
  echo "Error: File NODE_TYPE empty. You must have a node type, please contact with support@alastria.io"
  exit
fi

if [ "$NODE_TYPE" == "bootnode" ]; then
   docker pull alastria-node-bootnode
 else
   if [ "$NODE_TYPE" == "validator" ]; then
    docker pull alastria-node-validator
 else
   if [ "$NODE_TYPE" == "general" ]; then
    docker pull alastria-node-general
  fi
  fi
fi
./destroy_docker.sh
./launch_docker.sh