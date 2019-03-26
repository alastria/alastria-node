#!/bin/bash

set -e

CONSTELLATION=${ENABLE_CONSTELLATION:-}
LOGSTATS=$(ps -ef | grep '[l]ogrotate' | awk '{print $2}')

mapfile -t NODE_TYPE <~/alastria/data/NODE_TYPE

if [ "$NODE_TYPE" == "general" ] && [ ! -z "$CONSTELLATION" ]; then
    pkill -f constellation-node
fi

if [ ! -z "$LOGSTATS" ]
then
  echo "Stopping logrotate ..."
  kill -9 "$LOGSTATS"
  killall sleep
  echo "$(ps -ef | egrep 'logrotate|sleep' | grep -v grep )"
else
  echo "no Logrotate"
fi

pkill -f geth

set +e
