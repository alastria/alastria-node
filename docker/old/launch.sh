#!/bin/bash
DATA_DIR="$(cat DATA_DIR 2> /dev/null)"
WORK_DIR="$(pwd)"/alastria
DATA_DIR=${DATA_DIR:-$WORK_DIR}

NODE_NAME="$(cat NODE_NAME 2> /dev/null)"
NODE_NAME=${NODE_NAME:-REG_UNNAMED_TestNet_2_4_00}

NODE_TYPE="$(cat NODE_TYPE 2> /dev/null)"
NODE_TYPE=${NODE_TYPE:-general}

echo DATA_DIR=$DATA_DIR >> .env
echo NODE_NAME=$NODE_NAME >> .env
echo NODE_TYPE=$NODE_TYPE >> .env

docker-compose up