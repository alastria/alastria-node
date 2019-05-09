#!/bin/bash

echo "[*] Updating base code"
cd ~/alastria-node && git pull

mapfile -t NODE_TYPE <~/alastria/data/NODE_TYPE
echo "[*] Updating permissioned-nodes" 
~/alastria-node/scripts/updatePerm.sh "$NODE_TYPE"

echo "[*] Stopping node" 
~/alastria-node/scripts/stop.sh
sleep 5
GETH="$(pgrep geth)"
if [[ ! -z "$GETH" ]]; then
   pkill -f geth
   echo "geth is till running, please check!!"
   echo "geth pid is $GETH"
   echo "once stopped please run "
   echo ""
   echo " ~/alastria-node/scripts/start.sh"
 else
   echo "[*] Starting node" 
   ~/alastria-node/scripts/start.sh 
fi

