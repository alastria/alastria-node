#!/bin/bash

NODE_NAME="REG_BABELDOCKER_TestNet_2_4_00"
NODE_TYPE="general"
echo "Write node name (REG/VAL_COMP-NAME_network_CPU_RAM_DISK): "
read NODE_NAME
echo "Node name: "$NODE_NAME
echo ""
PS3='Please select node type: '
options=("Regulator" "Validator" "Exit")
select opt in "${options[@]}"
do
  case $opt in
    "Regulator")
      echo "You chose type regulator"
      NODE_TYPE="general"
      break;
      ;;
    "Validator")
      echo "You chose type validator"
      NODE_TYPE="validator"
      break;
      ;;
    "Exit")
      exit 0
      ;;
    *) echo "invalid option $REPLY";;
  esac
done

NODE_NAME="$(echo $NODE_NAME 2> /dev/null)"
NODE_NAME=${NODE_NAME:-REG_UNNAMED_TestNet_2_4_00}
echo "Final node name: "$NODE_NAME
NODE_TYPE="$(echo $NODE_TYPE 2> /dev/null)"
NODE_TYPE=${NODE_TYPE:-general}
echo "Final node type: "$NODE_TYPE

docker build -t alastria-node .
docker run alastria-node $NODE_TYPE $NODE_NAME