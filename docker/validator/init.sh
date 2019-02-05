#!/bin/bash

NODE_NAME,COMPANY_NAME,CPU,RAM,SEQ
NODE_TYPE="validator"

function setcompanyname {
  echo "Write company name: "
  read COMPANY_NAME
  echo "Company name: "$COMPANY_NAME
  echo ""
}
function setcpunumber {
  echo "Number of CPUs: "
  read CPU
  echo "CPUs: "$CPU
  echo ""
}
function setramnumber {
  echo "Number of RAM: "
  read RAM
  echo "RAM: "$RAM
  echo ""
}
function setsequential {
  echo "Sequential starting at 00: "
  read SEQ
  echo "SEQ: "$SEQ
  echo ""
}
setcompanyname
setcpunumber
setramnumber
setsequential

NODE_NAME=$(printf "%s%s%s%s%s%s%s%s" "VAL_" "$COMPANY_NAME" "_Telsius_" "$CPU" "_" "$RAM" "_" "$SEQ")
function checkname {
  PS3="Are you sure that these data are correct $NODE_NAME :"
  options=("Yes" "No")

  select opt in "${options[@]}"
  do
    case $opt in
      "Yes")
        echo "Starting regular node"
        docker build -t alastria-node-validator .
        docker run alastria-node-validator $NODE_TYPE $NODE_NAME
        ;;
      "No")
        echo "Please launch the script again"
        exit 0
        ;;
    esac
  done
}

checkname
