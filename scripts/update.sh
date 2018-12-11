#!/bin/bash

echo "[*] Updating base code"
cd ~/alastria-node && git pull

mapfile -t NODE_TYPE <~/alastria/data/NODE_TYPE
echo "[*] Updating permissioned-nodes" 
./updatePerm.sh "$NODE_TYPE"

echo "[*] Restarting node" 
~/alastria-node/scripts/stop.sh
~/alastria-node/scripts/start.sh
