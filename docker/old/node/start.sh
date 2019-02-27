#!/bin/bash
NODE_NAME=$(head -n 1 NODE_NAME)

if ( [  -z "$NODE_NAME" ] )
then
  echo "Error: File NODE_NAME empty"
else
  docker start $NODE_NAME
fi