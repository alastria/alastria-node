#!/bin/bash
# Prepare the node for a clean restart

echo "Preparing the node for a clean restart ..."
rm -Rf ~/alastria/logs/quorum*
rm -Rf ~/alastria/data/geth/chainData
rm -Rf ~/alastria/data/geth/nodes
rm ~/alastria/data/geth/LOCK
rm ~/alastria/data/geth/transactions.rpl
rm ~/alastria/data/geth.ipc
rm -Rf ~/alastria/data/quorum-raft-state
rm -Rf ~/alastria/data/raft-snap
rm -Rf ~/alastria/data/raft-wal
rm -Rf ~/alastria/data/constellation/data
rm ~/alastria/data/constellation/constellation.ipc
