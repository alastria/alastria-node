#!/bin/bash
# Prepare the node for a clean restart

echo "Preparing the node for a clean restart ..."
rm -Rf ~/alastria/logs/*
rm -Rf ~/alastria/data/keystore/*
rm -Rf ~/alastria/data/geth/nodekey
rm -Rf ~/alastria/data/constellation/keystore/*