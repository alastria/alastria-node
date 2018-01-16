#!/bin/bash
set -u
set -e

_TIME=$(date +%Y%m%d%H%M%S)

script ~/alastria/logs/monitor__"${_TIME}".log

geth -exec 'admin.nodeInfo' attach ~/alastria/data/geth.ipc
geth -exec 'admin.peers.length' attach ~/alastria/data/geth.ipc
geth -exec 'admin.peers' attach ~/alastria/data/geth.ipc
geth -exec 'eth.blockNumber' attach ~/alastria/data/geth.ipc
geth -exec 'eth.pendingTransactions' attach ~/alastria/data/geth.ipc
geth -exec 'istanbul.candidates' attach ~/alastria/data/geth.ipc
geth -exec 'istanbul.getValidators()' attach ~/alastria/data/geth.ipc
geth -exec 'net.peerCount' attach ~/alastria/data/geth.ipc
geth -exec 'net.version' attach ~/alastria/data/geth.ipc
geth -exec 'txpool.content' attach ~/alastria/data/geth.ipc

exit

set +u
set +e
