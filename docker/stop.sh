#!/bin/bash
NODE_NAME=$(head -n 1 NODE_NAME 2> /dev/null)

if ( [ -z "$NODE_NAME" ] )
then
  echo "Error: File NODE_NAME empty"
  exit
else
  docker exec -it $NODE_NAME bash -c "cd /root/alastria-node/scripts && ./stop.sh && ./monitor.sh stop"
  docker stop $NODE_NAME
fi

