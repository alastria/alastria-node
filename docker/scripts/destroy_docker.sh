#!/bin/bash
NODE_NAME=$(head -n 1 NODE_NAME 2> /dev/null)

if ( [ -z "$NODE_NAME" ] )
then
  echo "Error: File NODE_NAME empty. You must have a node name, please contact with support@alastria.io"
  exit
fi

./stop.sh && docker rm -f $NODE_NAME