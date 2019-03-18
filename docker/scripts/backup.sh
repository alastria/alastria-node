#!/bin/bash
DIRECTORY="../config"

if [ "$1" == "all" ]; then
    OPT=all
    echo "[*] Making a backup of the keys and chain data... "
# Backup only the keys by default
elif [ "$1" == "" ]; then
    OPT=keys
    echo "[*] Making a backup of the keys... "
fi

DATA_DIR="$(cat $DIRECTORY/DATA_DIR 2> /dev/null)"
WORK_DIR="$(pwd)"/alastria
DATA_DIR=${DATA_DIR:-$WORK_DIR}

NODE_NAME="$(cat $DIRECTORY/NODE_NAME 2> /dev/null)"
NODE_NAME=${NODE_NAME:-REG_UNNAMED_TestNet_2_4_00}

ARCHIVE=$NODE_NAME_$(date +%Y%m%d%H%M%S)_$OPT.xz
CUID=$UID

echo "[*] Stopping container... "
./stop.sh 2> /dev/null; sleep 10
mkdir -p backups; cd backups
BACKUPS="$(pwd)"
cd $DATA_DIR
if [ "$OPT" == "keys" ]; then
    tar -cvzf $BACKUPS/$ARCHIVE \
        data/passwords.txt \
        data/keystore \
        data/constellation/keystore \
        data/geth/nodekey
else
    tar -cvzf $BACKUPS/$ARCHIVE .
fi
cd $BACKUPS
echo "[*] Starting container... "
sudo chown $CUID:$CUID $ARCHIVE \
&& cd .. && ./start.sh 2> /dev/null

echo "[*] Backup stored in ./backups/$ARCHIVE"
echo "Done!"