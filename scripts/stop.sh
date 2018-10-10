#!/bin/bash

set -e

function superuser {
  if ( type "sudo"  > /dev/null 2>&1 )
  then
    sudo $@
  else
    eval $@
  fi
}

CONSTELLATION=${ENABLE_CONSTELLATION:-}

mapfile -t NODE_TYPE <~/alastria/data/NODE_TYPE

if [ -e /etc/cron.d/restart-node-cron ] && [ "reinicio" != "$1" ]; then
    superuser rm /etc/cron.d/restart-node-cron
fi

if [ "$NODE_TYPE" == "general" ] && [ ! -z "$CONSTELLATION" ]; then
    pkill -f constellation-node
fi

pkill -f geth

set +e
