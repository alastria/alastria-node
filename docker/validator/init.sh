#!/bin/bash

NODE_TYPE="validator"
NODE_NAME="VAL_"
MONITOR_ENABLED=1

function setCompanyName {
  echo "Write company name: "
  read COMPANY_NAME
  echo ""
}
function setCPUNumber {
  echo "Number of CPUs: "
  read CPU
  echo ""
}
function setRAMNumber {
  echo "Number of RAM: "
  read RAM
  echo ""
}
function setSequential {
  echo "Sequential starting at 00: "
  read SEQ
  echo ""
}


function launchNode {
  DIRECTORY=../config
  if [ ! -d "$DIRECTORY" ]; then
    mkdir $DIRECTORY
  fi
  DATA_DIR="$(pwd)"/alastria
  ACCESS_POINT_DIR="$(pwd)"/alastria-access-point/nginx/conf.d
  echo $NODE_NAME > $DIRECTORY/NODE_NAME
  echo $NODE_TYPE > $DIRECTORY/NODE_TYPE
  echo $MONITOR_ENABLED > $DIRECTORY/MONITOR_ENABLED
  echo $DATA_DIR > $DIRECTORY/DATA_DIR
  echo $ACCESS_POINT_DIR > $DIRECTORY/ACCESS_POINT_DIR

  docker run --name $NODE_NAME -v $DATA_DIR:/root/alastria -v $ACCESS_POINT_DIR:/etc/nginx/conf.d -p 21000:21000 -p 21000:21000/udp -p 8443:8443 -p 22000:22000 -p 80:80 -p 443:443 -e NODE_TYPE=$NODE_TYPE -e NODE_NAME=$NODE_NAME -e MONITOR_ENABLED=$MONITOR_ENABLED --restart unless-stopped alastria/alastria-node-validator
}

function checkName {
  PS3="Are you sure that these data are correct?"$'\n'"Node Type => $NODE_TYPE"$'\n'"Node Name => $NODE_NAME"$'\n'"Data path: => $DATA_DIR"$'\n'"Access point path: => $ACCESS_POINT_DIR"$'\n'"Press 1 (Yes) or 2 (No) => "
  options=("Yes" "No")

  select opt in "${options[@]}"
  do
    case $opt in
      "Yes")
        echo "Starting node"
        launchNode
        ;;
      "No")
        echo "Please launch the script again"
        exit 0
        ;;
    esac
  done
}

setCompanyName
setCPUNumber
setRAMNumber
setSequential

NODE_NAME=$(printf "%s%s%s%s%s%s%s%s" "$NODE_NAME" "$COMPANY_NAME" "_Telsius_" "$CPU" "_" "$RAM" "_" "$SEQ")
checkName
