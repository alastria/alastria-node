#!/bin/bash
# Prepare the node for a clean restart

if ( [ "transactions" == "$1" ]); then 
    echo "Cleaning transaction queue ..."
    rm ~/alastria/data/geth/transactions.rlp
else
    echo "Preparing the node for a clean restart ..."
    rm -Rf ~/alastria/logs/quorum*
    rm -Rf ~/alastria/data/geth/chainData
    rm -Rf ~/alastria/data/geth/nodes
    rm ~/alastria/data/geth/LOCK
    rm ~/alastria/data/geth/transactions.rlp
    rm ~/alastria/data/geth.ipc
    rm -Rf ~/alastria/data/quorum-raft-state
    rm -Rf ~/alastria/data/raft-snap
    rm -Rf ~/alastria/data/raft-wal
    rm -Rf ~/alastria/data/constellation/data
    rm ~/alastria/data/constellation/constellation.ipc
fi
