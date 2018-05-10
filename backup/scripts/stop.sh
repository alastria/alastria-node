#!/bin/bash

set -e

mapfile -t NODE_TYPE <~/alastria/data/NODE_TYPE

if [[ "$NODE_TYPE" == "general" ]]; then
    pkill -f constellation-node
fi

pkill -f geth

set +e