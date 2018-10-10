#!/bin/bash
set -u
set -e

MESSAGE='Usage: start.sh <--clean> <--no-monitor> <--watch>'

function superuser {
  if ( type "sudo"  > /dev/null 2>&1 )
  then
    sudo $@
  else
    eval $@
  fi
}

MONITOR=1
WATCH=0
CLEAN=0
USER=$( id -un )
NPATH=$(printenv | grep -w PATH)

while [[ $# -gt 0  ]]
do
  key="$1"
  case "$key" in
    -m|-M|--no-monitor)
    MONITOR=0
    ;;
    -w|-W|--watch)
    WATCH=1
    ;;
    -c|-C|--clean)
    CLEAN=1
    ;;
    -h|-H|--help)
    echo $MESSAGE
    exit
    ;;
  esac
  shift
done

CURRENT_HOST_IP="$(dig +short myip.opendns.com @resolver1.opendns.com 2>/dev/null || curl -s --retry 2 icanhazip.com)"
CONSTELLATION_PORT=9000

check_constellation_isStarted(){
    set +e
    RETVAL=""
    while [ "$RETVAL" == "" ]
    do
    
        RETVAL="$(ss -nutlp | grep $CONSTELLATION_PORT)"
        [ "$RETVAL" != "" ] && echo "[*] constellation node at $CONSTELLATION_PORT is now up."
        [ "$RETVAL" == "" ] && echo "[*] constellation node at $CONSTELLATION_PORT is still starting. Awaiting 5 seconds." && sleep 5

    done
    echo "[*] resuming start procedure"
    set -e
}

NETID=82584648528
mapfile -t IDENTITY <~/alastria/data/IDENTITY
GLOBAL_ARGS="--networkid $NETID --identity $IDENTITY --permissioned --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul --rpcport 22000 --port 21000 --istanbul.requesttimeout 10000  --ethstats $IDENTITY:bb98a0b6442386d0cdf8a31b267892c1@netstats.testnet.alastria.io.builders:80 --verbosity 3 --vmdebug --emitcheckpoints --targetgaslimit 18446744073709551615 --syncmode full --vmodule consensus/istanbul/core/core.go=5 "

_TIME=$(date +%Y%m%d%H%M%S)

mapfile -t NODE_TYPE <~/alastria/data/NODE_TYPE

if ([ $CLEAN -gt 0 ])
then
    echo "Cleaning your node ..."
    rm -rf ~/alastria/logs/quorum_*
    rm -rf ~/alastria/data/geth/chainData
    rm -rf ~/alastria/data/geth/nodes
    rm -f ~/alastria/data/geth/transactions.rlp
    rm -f ~/alastria/data/geth.ipc
    rm -rf ~/alastria/data/constellation/data
    rm -f ~/alastria/data/constellation/constellation.ipc
    rm -rf ~/alastria/data/geth/lightchaindata
    rm -rf ~/alastria/data/geth/chaindata

    ./init.sh auto $NODE_TYPE $IDENTITY
fi

CONSTELLATION=${ENABLE_CONSTELLATION:-}

if [ "$NODE_TYPE" == "general" ] && [ ! -z "$CONSTELLATION" ]; then
    echo "[*] Starting Constellation node"
    nohup constellation-node ~/alastria/data/constellation/constellation.conf 2>> ~/alastria/logs/constellation_"${_TIME}".log &
    check_constellation_isStarted
fi

if [[ ! -f "permissioned-nodes.json" ]]; then
    # Se corrige el arranque del nodo en docker.
    rm -Rf permissioned-nodes.json
    # Esto es necesario por un bug de Quorum https://github.com/jpmorganchase/quorum/issues/225
    ln -s ~/alastria/data/permissioned-nodes.json permissioned-nodes.json
    echo "Relinking permissioning file"
fi

echo "[*] Starting quorum node"
if [[ "$NODE_TYPE" == "general" ]]; then
  if [[ ! -z "$CONSTELLATION" ]]; then
      nohup env PRIVATE_CONFIG=~/alastria/data/constellation/constellation.conf geth --datadir ~/alastria/data $GLOBAL_ARGS 2>> ~/alastria/logs/quorum_"${_TIME}".log &
    else
      nohup env geth --datadir ~/alastria/data $GLOBAL_ARGS 2>> ~/alastria/logs/quorum_"${_TIME}".log &
fi
else
    if [[ "$NODE_TYPE" == "validator" ]]; then
        if [[ "$CURRENT_HOST_IP" == "52.56.69.220" ]]; then
            nohup geth --datadir ~/alastria/data $GLOBAL_ARGS --maxpeers 100 --mine --minerthreads $(grep -c "processor" /proc/cpuinfo) --unlock 0 --password ~/alastria/data/passwords.txt 2>> ~/alastria/logs/quorum_"${_TIME}".log &
        else
            nohup geth --datadir ~/alastria/data $GLOBAL_ARGS --maxpeers 100 --mine --minerthreads $(grep -c "processor" /proc/cpuinfo) 2>> ~/alastria/logs/quorum_"${_TIME}".log &
        fi
    fi
fi

if ( [ ! -e /etc/cron.d/restart-node-cron ] ); then
    if [ ! -z "$CONSTELLATION" ]; then
	CONSTELL=$(printenv | grep -w ENABLE_CONSTELLATION)
	echo -e "0 23 */2 * * $USER cd ~/alastria-node/scripts/;export $NPATH;export $CONSTELL;./restart.sh auto; \n" | superuser tee -a /etc/cron.d/restart-node-cron
    else
	echo -e "0 23 */2 * * $USER cd ~/alastria-node/scripts/;env $NPATH ./restart.sh auto; \n" | superuser tee -a /etc/cron.d/restart-node-cron
    fi
	superuser chmod 0644 /etc/cron.d/restart-node-cron
	superuser /etc/init.d/cron start
fi

if ([ $MONITOR -gt 0 ])
then
    echo "[*] Monitor enabled. Starting monitor..."
    RP=`readlink -m "$0"`
    RD=`dirname "$RP"`
    nohup $RD/monitor.sh start > /dev/null &
else
    echo "Monitor disabled."
fi

if ([ $WATCH -gt 0 ])
then
  tail -100f ~/alastria/logs/quorum_"${_TIME}".log
fi

set +u
set +e
