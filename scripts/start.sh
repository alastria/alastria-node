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

if [[ ! -f ~/alastria/data/RAFT_ID && "$CURRENT_HOST_IP" != "52.56.69.220" ]]; then
    echo "[*] The node don't have ~/alastria/data/RAFT_ID file, please:"
    echo " "
    echo "      Update DIRECTORY.md from alastria-node repository and send a Pull Request."
    echo "      The network administrator will send a RAFT_ID file. It will be stored in '~/alastria/data/' directory."
    echo " " 
    exit
fi

NETID=963262369
GLOBAL_ARGS="--networkid $NETID --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,raft --rpcport 22000 --port 21000 --raftport 41000 "

_TIME=$(date +%Y%m%d%H%M%S)

echo "[*] Starting Constellation node"
nohup constellation-node ~/alastria/data/constellation/constellation.conf 2>> ~/alastria/logs/constellation_"${_TIME}".log &
sleep 6

echo "[*] Starting quorum node"
PRIVATE_CONFIG=~/alastria/data/constellation/constellation.conf
# Se elimina --permissioned por fallo en el nodo 'Alastria'
if [ -f ~/alastria/data/RAFT_ID ]; then 
    mapfile -t RAFT_ID <~/alastria/data/RAFT_ID
    nohup geth --datadir ~/alastria/data $GLOBAL_ARGS --raftjoinexisting $RAFT_ID --bootnodes enode://3905f943ba5446eba164c07ab5f53a84ce17d74ec4d7591f6ec54b9d7608f57cae7cfdf946616385f59cfb5b910161a1f8520cb6f992bcc0d1ab932601205e91@52.56.69.220:21000?raftport=41000 2>> ~/alastria/logs/quorum_"${_TIME}".log &
else
    if [[ "$CURRENT_HOST_IP" == "52.56.69.220" ]]; then
        nohup geth --datadir ~/alastria/data $GLOBAL_ARGS --unlock 0 --password ~/alastria/data/passwords.txt 2>> ~/alastria/logs/quorum_"${_TIME}".log &
    fi
fi

set +u
set +e
