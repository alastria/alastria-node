#!/bin/bash
NODE_NAME="$(cat NODE_NAME 2> /dev/null)"
NODE_NAME=${NODE_NAME:-REG_UNNAMED_TestNet_2_4_00}
./stop.sh && docker rm -f $NODE_NAME
