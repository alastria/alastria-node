#!/bin/bash

set -e

CONSTELLATION=${ENABLE_CONSTELLATION:-}

mapfile -t NODE_TYPE <~/alastria/data/NODE_TYPE

if [ "$NODE_TYPE" == "general" ] && [ ! -z "$CONSTELLATION" ]; then
    pkill -f constellation-node
fi

pkill -f geth

# If monitor is enabled, never stops.
./monitor.sh stop

set +e
