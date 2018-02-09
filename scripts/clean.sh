#!/bin/bash
# Prepare the node for a clean restart

echo "Preparing the node for a clean restart ..."
rm -rf ~/alastria/logs/*
rm -rf ~/alastria/data/geth/chainData
rm -rf ~/alastria/data/geth/nodes
# Optional in case you start with process locked
rm -f ~/alastria/data/geth/LOCK
rm -f ~/alastria/data/geth/transactions.rlp
rm -f ~/alastria/data/geth.ipc
#rm -f ~/alastria/data/quorum-raft-state
#rm -f ~/alastria/data/raft-snap
#rm -f ~/alastria/data/raft-wal
rm -rf ~/alastria/data/constellation/data
rm -f ~/alastria/data/constellation/constellation.ipc
rm -rf ~/alastria/data/geth/lightchaindata
rm -rf ~/alastria/data/geth/chaindata

