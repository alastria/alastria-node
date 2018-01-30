#!/bin/bash
set -u
set -e

_TIME=$(date +%Y%m%d%H%M%S)

echo `lsof -i | grep *:21000 | awk '{print $8 $9 $10}'` >> ~/alastria/logs/monitor__"${_TIME}".log
echo `lsof -i | grep *:22000 | awk '{print $8 $9 $10}'` >> ~/alastria/logs/monitor__"${_TIME}".log
echo `lsof -i | grep *:9000 | awk '{print $8 $9 $10}'` >> ~/alastria/logs/monitor__"${_TIME}".log

echo `geth -exec 'admin.nodeInfo' attach ~/alastria/data/geth.ipc` >> ~/alastria/logs/monitor__"${_TIME}".log
echo `geth -exec 'admin.peers' attach ~/alastria/data/geth.ipc` >> ~/alastria/logs/monitor__"${_TIME}".log
echo `geth -exec 'eth.blockNumber' attach ~/alastria/data/geth.ipc` >> ~/alastria/logs/monitor__"${_TIME}".log
echo `geth -exec 'eth.mining' attach ~/alastria/data/geth.ipc` >> ~/alastria/logs/monitor__"${_TIME}".log
echo `geth -exec 'eth.syncing' attach ~/alastria/data/geth.ipc` >> ~/alastria/logs/monitor__"${_TIME}".log
echo `geth -exec 'eth.pendingTransactions' attach ~/alastria/data/geth.ipc` >> ~/alastria/logs/monitor__"${_TIME}".log
echo `geth -exec 'istanbul.candidates' attach ~/alastria/data/geth.ipc` >> ~/alastria/logs/monitor__"${_TIME}".log
echo `geth -exec 'istanbul.getValidators()' attach ~/alastria/data/geth.ipc` >> ~/alastria/logs/monitor__"${_TIME}".log
echo `geth -exec 'net.peerCount' attach ~/alastria/data/geth.ipc` >> ~/alastria/logs/monitor__"${_TIME}".log
echo `geth -exec 'net.version' attach ~/alastria/data/geth.ipc` >> ~/alastria/logs/monitor__"${_TIME}".log
echo `geth -exec 'txpool.content' attach ~/alastria/data/geth.ipc` >> ~/alastria/logs/monitor__"${_TIME}".log

set +u
set +e
