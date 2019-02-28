#!/bin/bash

function setnodetype {
  PS3="Choose the node type: 1)general, 2)validator, 3)bootnode => "
  options=("general" "validator" "bootnode")

  select opt in "${options[@]}"
  do
    case $opt in
      "general")
        NODE_TYPE="general";
        NODE_NAME="REG_";
        break;;
      "validator")
        NODE_TYPE="validator";
        NODE_NAME="VAL_";
        break;;
      "bootnode")
        NODE_TYPE="bootnode";
        NODE_NAME="BOT_";
        break;;
      *)
        echo "Invalid choice '${REPLY}', please pick one of the above"
    esac
  done
}
function setcompanyname {
  echo "Write company name: "
  read COMPANY_NAME
  echo ""
}
function setcpunumber {
  echo "Number of CPUs: "
  read CPU
  echo ""
}
function setramnumber {
  echo "Number of RAM: "
  read RAM
  echo ""
}
function setsequential {
  echo "Sequential starting at 00: "
  read SEQ
  echo ""
}

function setMonitor {
  PS3="Do you want to install the monitor?"$'\n'"Press 1 (Yes) or 2 (No) => "
  options=("Yes" "No")

  select opt in "${options[@]}"
  do
    case $opt in
      "Yes")
        MONITOR_ENABLED=1
        break
        ;;
      "No")
        MONITOR_ENABLED=0
        break
        ;;
    esac
  done
}


setnodetype
setcompanyname
setcpunumber
setramnumber
setsequential
setMonitor

function launchnodetype {
  echo $NODE_NAME > NODE_NAME
  echo $NODE_TYPE > NODE_TYPE
  echo $MONITOR_ENABLED > MONITOR_ENABLED
  echo $DATA_DIR > DATA_DIR
  if [ "validator" == "$NODE_TYPE" ]; then
    docker run --name $NODE_NAME -v $DATA_DIR:/root/alastria -e NODE_TYPE=$NODE_TYPE -e NODE_NAME=$NODE_NAME -p 21000:21000 -p 21000:21000/udp -p 8443:8443 -p 127.0.0.1:22000:22000 --restart unless-stopped alastria-node
  elif [ "general" == "$NODE_TYPE" ]; then
    docker run --name $NODE_NAME -v alastria:/root/alastria -p 22000:22000 -p 21000:21000 -p 21000:21000/udp -p 9000:9000 -p 8443:8443 -e NODE_TYPE=$NODE_TYPE -e NODE_NAME=$NODE_NAME -e MONITOR_ENABLED=$MONITOR_ENABLED --restart unless-stopped alastria-node
  elif [ "bootnode" == "$NODE_TYPE" ]; then
    docker run --name $NODE_NAME -v $DATA_DIR:/root/alastria -e NODE_TYPE=$NODE_TYPE -e NODE_NAME=$NODE_NAME -p 21000:21000 -p 21000:21000/udp -p 8443:8443 --restart unless-stopped alastria-node
  fi
}

function checkname {
  PS3="Are you sure that these data are correct?"$'\n'"Node Type => $NODE_TYPE"$'\n'"Node Name => $NODE_NAME"$'\n'"Press 1 (Yes) or 2 (No) => "
  options=("Yes" "No")

  select opt in "${options[@]}"
  do
    case $opt in
      "Yes")
        echo "Starting node"
        launchnodetype
        # docker run alastria-node $NODE_TYPE $NODE_NAME -p 22000:22000
        ;;
      "No")
        echo "Please launch the script again"
        exit 0
        ;;
    esac
  done
}

NODE_NAME=$(printf "%s%s%s%s%s%s%s%s" "$NODE_NAME" "$COMPANY_NAME" "_Telsius_" "$CPU" "_" "$RAM" "_" "$SEQ")
checkname
