#!/bin/bash

set -e

CONSTELLATION=${ENABLE_CONSTELLATION:-}

mapfile -t NODE_TYPE <~/alastria/data/NODE_TYPE

if ([ -e /etc/cron.d/restart-node-cron ]); then
    rm /etc/cron.d/restart-node-cron
fi

if [ "$NODE_TYPE" == "general" ] && [ ! -z "$CONSTELLATION" ]; then
    pkill -f constellation-node
fi

pkill -f geth

set +e
