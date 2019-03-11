#!/bin/bash
DIRECTORY="../config"
NODE_NAME=$(head -n 1 $DIRECTORY/NODE_NAME 2> /dev/null)

if ( [ -z "$NODE_NAME" ] )
then
  echo "Error: File NODE_NAME empty"
  exit
else
  docker start $NODE_NAME
fi