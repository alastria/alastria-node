#!/bin/bash
set -u
set -e

CURRENT_HOST_IP="$(dig +short myip.opendns.com @resolver1.opendns.com 2>/dev/null || curl -s --retry 2 icanhazip.com)"

echo "Optional use for a clean start: start clean"

if ( [ "clean" == "$1" ]); then 

    echo "Cleaning your node ..."
    #Backup directory tree
    rm -Rf ~/alastria-backup-$CURRENT_DATE/logs/*
    rm -Rf ~/alastria-backup-$CURRENT_DATE/data/geth/chainData
    rm -Rf ~/alastria-backup-$CURRENT_DATE/data/geth/nodes
    rm ~/alastria-backup-$CURRENT_DATE/data/geth/LOCK
    rm ~/alastria-backup-$CURRENT_DATE/data/geth/transactions.rpl
    rm ~/alastria-backup-$CURRENT_DATE/data/geth.ipc
    rm -Rf ~/alastria-backup-$CURRENT_DATE/data/quorum-raft-state
    rm -Rf ~/alastria-backup-$CURRENT_DATE/data/raft-snap
    rm -Rf ~/alastria-backup-$CURRENT_DATE/data/raft-wal
    rm -Rf ~/alastria-backup-$CURRENT_DATE/data/constellation/data
    rm ~/alastria-backup-$CURRENT_DATE/data/constellation/constellation.ipc
fi

NETID=953474359
mapfile -t IDENTITY <~/alastria/data/IDENTITY
GLOBAL_ARGS="--networkid $NETID --identity $IDENTITY --permissioned --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul --rpcport 22000 --port 21000 "

_TIME=$(date +%Y%m%d%H%M%S)

mapfile -t NODE_TYPE <~/alastria/data/NODE_TYPE

echo "[*] Starting Constellation node"
if [[ "$NODE_TYPE" == "general" ]]; then
    nohup constellation-node ~/alastria/data/constellation/constellation.conf 2>> ~/alastria/logs/constellation_"${_TIME}".log &
    sleep 6
fi

echo "[*] Starting quorum node"
if [[ "$NODE_TYPE" == "general" ]]; then
    PRIVATE_CONFIG=~/alastria/data/constellation/constellation.conf
    nohup geth --datadir ~/alastria/data $GLOBAL_ARGS 2>> ~/alastria/logs/quorum_"${_TIME}".log &
else
    if [[ "$NODE_TYPE" == "validator" ]]; then
        if [[ "$CURRENT_HOST_IP" == "52.56.69.220" ]]; then
            nohup geth --datadir ~/alastria/data $GLOBAL_ARGS --mine --minerthreads 1 --syncmode "full" --unlock 0 --password ~/alastria/data/passwords.txt 2>> ~/alastria/logs/quorum_"${_TIME}".log &
        else
            nohup geth --datadir ~/alastria/data $GLOBAL_ARGS --mine --minerthreads 1 --syncmode "full" 2>> ~/alastria/logs/quorum_"${_TIME}".log &
        fi
    fi
fi

set +u
set +e
