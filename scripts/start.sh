#!/bin/bash
set -u
set -e

NETID=963232369
GLOBAL_ARGS="--networkid $NETID --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum"

_TIME=$(date +%Y%m%d%H%M%S)

echo "[*] Starting Constellation node"
nohup constellation-node ~/alastria/data/constellation/constellation.conf 2>> ~/alastria/logs/constellation_"${_TIME}".log &
sleep 6

echo "[*] Starting quorum node"
PRIVATE_CONFIG=~/alastria/data/constellation/constellation.conf
if ( [ $# -ne 1 ] ); then
    nohup geth --datadir ~/alastria/data $GLOBAL_ARGS --rpcport 22000 --port 21000 --password ~/alastria/data/passwords.txt 2>> ~/alastria/logs/quorum_"${_TIME}".log &
else
    nohup geth --datadir ~/alastria/data $GLOBAL_ARGS --rpcport 22000 --port 21000 --unlock 0 --password ~/alastria/data/passwords.txt 2>> ~/alastria/logs/quorum_"${_TIME}".log &
fi

set +u
set +e
