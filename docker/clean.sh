#!/bin/bash
DATA_DIR="$(cat DATA_DIR 2> /dev/null)"
WORK_DIR="$(pwd)"/alastria-node
DATA_DIR=${DATA_DIR:-$WORK_DIR}
./backup.sh all; sudo rm -rf $DATA_DIR
