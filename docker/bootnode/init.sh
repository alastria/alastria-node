#!/bin/bash

NODE_TYPE="bootnode"
NODE_NAME="BOT_"
MONITOR_ENABLED=1
ENABLE_CONSTELLATION=

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

function setVolume {
  echo "Set the absolute path of the data directory (default: $(pwd))"
  read DATA_DIR
  echo ""
  WORK_DIR="$(pwd)"/alastria
  DATA_DIR=${DATA_DIR:-$WORK_DIR}
}

function launchNodeType {
  echo $NODE_NAME > NODE_NAME
  echo $NODE_TYPE > NODE_TYPE
  echo $MONITOR_ENABLED > MONITOR_ENABLED
  echo $DATA_DIR > DATA_DIR
  echo $ENABLE_CONSTELLATION > ENABLE_CONSTELLATION

  docker run --name $NODE_NAME -v $DATA_DIR:/root/alastria -p 21000:21000 -p 21000:21000/udp -p 8443:8443  -e NODE_TYPE=$NODE_TYPE -e NODE_NAME=$NODE_NAME -e MONITOR_ENABLED=$MONITOR_ENABLED -e ENABLE_CONSTELLATION=$ENABLE_CONSTELLATION --restart unless-stopped alastria-node-bootnode
}

function checkName {
  PS3="Are you sure that these data are correct?"$'\n'"Node Type => $NODE_TYPE"$'\n'"Node Name => $NODE_NAME"$'\n'"Press 1 (Yes) or 2 (No) => "
  options=("Yes" "No")

  select opt in "${options[@]}"
  do
    case $opt in
      "Yes")
        echo "Starting bootnode"
        launchNodeType
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
setVolume

NODE_NAME=$(printf "%s%s%s%s%s%s%s%s" "$NODE_NAME" "$COMPANY_NAME" "_Telsius_" "$CPU" "_" "$RAM" "_" "$SEQ")
checkName
