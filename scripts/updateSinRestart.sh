#!/bin/bash

echo "[*] Updating base code"
cd ~/alastria-node && git pull

mapfile -t NODE_TYPE <~/alastria/data/NODE_TYPE
echo "[*] Updating permissioned-nodes"
~/alastria-node/scripts/updatePerm.sh "$NODE_TYPE"

