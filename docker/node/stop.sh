#!/bin/bash
NODE_NAME=$(head -n 1 NODE_NAME)
NODE_NAME=${NODE_NAME:-REG_UNNAMED_TestNet_2_4_00}

if ( [ "" == "$NODE_NAME" ] )
then
  echo "Error: File NODE_NAME empty"
else
  docker exec -ti $NODE_NAME bash -c "cd /root/alastria-node/scripts && ./stop.sh && ./monitor.sh stop"
  docker stop $NODE_NAME
fi

