#!/bin/bash
set -u
set -e

kill_geth() {
    echo "He entrado en kill_geth" > KILL_GETH
    pkill -f geth
}
trap kill_geth SIGTERM

MESSAGE='Usage: start.sh <--clean> <--no-monitor> <--watch> <--local-rpc> <--logrotate>'

MONITOR=0
WATCH=0
CLEAN=0
GCMODE="full"
RPCADDR=0.0.0.0
LOGROTATE=0

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
    -a|-A|--archive)
    GCMODE="archive"
    ;;
    -l|-L|--local-rpc)
    RPCADDR=127.0.0.1
    ;;
    -r|-R|--logrotate)
    LOGROTATE=1
    ;;
    -h|-H|--help)
    echo $MESSAGE
    exit
    ;;
  esac
  shift
done

VALIDATOR0_HOST_IP="$(dig +short validator0.telsius.alastria.io @resolver1.opendns.com > /dev/null 2>&1 || curl -s --retry 2 icanhazip.com)"
CURRENT_HOST_IP="$(dig +short myip.opendns.com @resolver1.opendns.com > /dev/null 2>&1 || curl -s --retry 2 icanhazip.com)"
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

NETID=83584648538
mapfile -t IDENTITY <~/alastria/data/IDENTITY
mapfile -t NODE_TYPE <~/alastria/data/NODE_TYPE

#
# options for metrics generation to InfluxDB server
#
#!/bin/bash


GETH_VERSION=$(geth version|grep ^Version|awk '{print $2}')
if [[ $GETH_VERSION =~ 1\.8 ]]; then

	INFLUX_METRICS=" --metrics --metrics.influxdb --metrics.influxdb.endpoint http://geth-metrics.planisys.net:8086 --metrics.influxdb.database alastria --metrics.influxdb.username alastriausr --metrics.influxdb.password ala0str1AX1 --metrics.influxdb.host.tag=${IDENTITY}"

elif [[ $GETH_VERSION =~ 1\.9 ]]; then

	# includes prometheus aside of influx with pprof options, slight change in influx options syntax

	INFLUX_METRICS=" --metrics --metrics.expensive  --pprof --pprofaddr 0.0.0.0 --pprofport 9545 --metrics.influxdb --metrics.influxdb.endpoint http://geth-metrics.planisys.net:8086 --metrics.influxdb.database alastria --metrics.influxdb.username alastriausr --metrics.influxdb.password ala0str1AX1 --metrics.influxdb.tags host=${IDENTITY}"

fi


# increase verbosity 5 to collect more logs

if [ "$NODE_TYPE" == "bootnode" ]; then

   #GLOBAL_ARGS="--networkid $NETID --identity $IDENTITY --permissioned --port 21000 --ethstats $IDENTITY:bb98a0b6442386d0cdf8a31b267892c1@netstats.telsius.alastria.io:80 --targetgaslimit 8000000 --syncmode fast --nodiscover ${INFLUX_METRICS} --verbosity 5"
   GLOBAL_ARGS="--networkid $NETID --identity $IDENTITY --permissioned --port 21000 --ethstats $IDENTITY:bb98a0b6442386d0cdf8a31b267892c1@netstats.telsius.alastria.io:80 --targetgaslimit 8000000 --syncmode fast --nodiscover ${INFLUX_METRICS}"
else

   # set --cache 10 to avoid issue #804
   GLOBAL_ARGS="--networkid $NETID --identity $IDENTITY --permissioned --rpc --rpcaddr $RPCADDR --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul --rpcport 22000 --port 21000 --istanbul.requesttimeout 10000  --ethstats $IDENTITY:bb98a0b6442386d0cdf8a31b267892c1@netstats.telsius.alastria.io:80 --verbosity 3 --vmdebug --emitcheckpoints --targetgaslimit 8000000 --syncmode full --gcmode $GCMODE --vmodule consensus/istanbul/core/core.go=5 --nodiscover ${INFLUX_METRICS}"
   #GLOBAL_ARGS="--networkid $NETID --identity $IDENTITY --permissioned --rpc --rpcaddr $RPCADDR --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul --rpcport 22000 --port 21000 --istanbul.requesttimeout 10000  --ethstats $IDENTITY:bb98a0b6442386d0cdf8a31b267892c1@netstats.telsius.alastria.io:80 --debug  --targetgaslimit 8000000 --syncmode fast --gcmode full --vmodule consensus/istanbul/core/core.go=5 --nodiscover ${INFLUX_METRICS}  --verbosity 5 --cache 10 "

fi

_TIME="_$(date +%Y%m%d%H%M%S)"

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

if ([ $LOGROTATE -gt 0 ])
then
   echo "Configuring logrotate ..."
   _TIME=""
   else
   _TIME="_$(date +%Y%m%d%H%M%S)"
fi

CONSTELLATION=${ENABLE_CONSTELLATION:-}


if [ "$NODE_TYPE" == "general" ] && [ ! -z "$CONSTELLATION"  ]; then
    echo "[*] Starting Constellation node"
    nohup constellation-node ~/alastria/data/constellation/constellation.conf 2>> ~/alastria/logs/constellation"${_TIME}".log &
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
      nohup env PRIVATE_CONFIG=~/alastria/data/constellation/constellation.conf geth --datadir ~/alastria/data $GLOBAL_ARGS 2>> ~/alastria/logs/quorum"${_TIME}".log &
    else
      nohup env PRIVATE_CONFIG=ignore geth --datadir ~/alastria/data $GLOBAL_ARGS 2>> ~/alastria/logs/quorum"${_TIME}".log &
      #nohup env geth --datadir ~/alastria/data $GLOBAL_ARGS 2>> ~/alastria/logs/quorum"${_TIME}".log &
  fi
else
    if [[ "$NODE_TYPE" == "validator" ]]; then
        nohup geth --datadir ~/alastria/data $GLOBAL_ARGS --maxpeers 100 --mine --minerthreads $(grep -c "processor" /proc/cpuinfo) 2>> ~/alastria/logs/quorum"${_TIME}".log &
    else
        if [[ "$NODE_TYPE" == "bootnode" ]]; then
            nohup geth --datadir ~/alastria/data $GLOBAL_ARGS --maxpeers 200 2>> ~/alastria/logs/quorum"${_TIME}".log &
        else
            echo "[ ] ERROR: $NODE_TYPE is not a correct node type."
        fi
    fi
fi

# have a unique path to look for logs
if [ -L ~/alastria/logs/quorum.log ]; then
	rm -f ~/alastria/logs/quorum.log
fi
ln -s ~/alastria/logs/quorum"${_TIME}".log ~/alastria/logs/quorum.log


if ([ $MONITOR -gt 0 ])
then
    echo "[*] Monitor enabled. Starting monitor..."
    RP=`readlink -m "$0"`
    RD=`dirname "$RP"`
    nohup $RD/monitor.sh start > /dev/null &
else
    echo "Monitor disabled."
fi

if ([ $LOGROTATE -gt 0 ]) 
then 
    RP=`readlink -m "$0"`
    RD=`dirname "$RP"`
    nohup $RD/logrotate.sh > /dev/null &
else
   echo "Logrotate disabled."
fi

set +u
set +e

if ([ $WATCH -gt 0 ])
then
  tail -100f ~/alastria/logs/quorum"${_TIME}".log
fi
  

