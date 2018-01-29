#!/bin/bash
set -u
set -e

CURRENT_HOST_IP="$(dig +short myip.opendns.com @resolver1.opendns.com 2>/dev/null || curl -s --retry 2 icanhazip.com)"

echo "Optional use for a clean start: start clean"

if ( [ ! $# -ne 1 ] && [ "clean" == "$1" ]); then 
    
    echo "Cleaning your node ..."
    #Backup directory tree
    rm -Rf ~/alastria/logs/*
    rm -Rf ~/alastria/data/geth/chainData
    rm -Rf ~/alastria/data/geth/nodes
    # Optional in case you start with process locked
    # rm ~/alastria/data/geth/LOCK
    rm ~/alastria/data/geth/transactions.rlp
    rm ~/alastria/data/geth.ipc
    rm -Rf ~/alastria/data/quorum-raft-state
    rm -Rf ~/alastria/data/raft-snap
    rm -Rf ~/alastria/data/raft-wal
    rm -Rf ~/alastria/data/constellation/data
    rm -Rf ~/alastria/data/constellation/constellation.ipc
fi

NETID=953474359
mapfile -t IDENTITY <~/alastria/data/IDENTITY
GLOBAL_ARGS="--networkid $NETID --identity $IDENTITY --permissioned --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul --rpcport 22000 --port 21000 --istanbul.requesttimeout 30000 "

_TIME=$(date +%Y%m%d%H%M%S)

mapfile -t NODE_TYPE <~/alastria/data/NODE_TYPE

if [[ "$NODE_TYPE" == "general" ]]; then
    echo "[*] Starting Constellation node"
    nohup constellation-node ~/alastria/data/constellation/constellation.conf 2>> ~/alastria/logs/constellation_"${_TIME}".log &
    sleep 20
fi

if [[ ! -f "permissioned-nodes.json" ]]; then
    # Esto es necesario por un bug de Quorum https://github.com/jpmorganchase/quorum/issues/225
    ln -s ~/alastria/data/permissioned-nodes.json permissioned-nodes.json
fi

echo "[*] Starting quorum node"
if [[ "$NODE_TYPE" == "general" ]]; then
    PRIVATE_CONFIG=~/alastria/data/constellation/constellation.conf nohup geth --datadir ~/alastria/data $GLOBAL_ARGS 2>> ~/alastria/logs/quorum_"${_TIME}".log &
else
    if [[ "$NODE_TYPE" == "validator" ]]; then
        if [[ "$CURRENT_HOST_IP" == "52.56.69.220" ]]; then
            nohup geth --datadir ~/alastria/data $GLOBAL_ARGS --mine --minerthreads 1 --syncmode "full" --unlock 0 --password ~/alastria/data/passwords.txt 2>> ~/alastria/logs/quorum_"${_TIME}".log &
        else
            nohup geth --datadir ~/alastria/data $GLOBAL_ARGS --mine --minerthreads 1 --syncmode "full" 2>> ~/alastria/logs/quorum_"${_TIME}".log &
        fi
    fi
fi

if ([ ! $# -ne 1 ] && [ "dockerfile" == "$1" ]); then 
    
    echo "Running your node ..."
    while true; do
        sleep 1000000
    done;
fi

set +u
set +e
