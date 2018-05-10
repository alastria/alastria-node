#!/bin/bash
# Makes a node backup

MESSAGE="Usage: backup keys | full"
if ( [ $# -ne 1 ] ); then
    echo "$MESSAGE"
    exit
fi

CURRENT_DATE=`date +%Y%m%d%H%M%S`


if ( [ "keys" == "$1" ]); then
    echo "Making a backup of your current node keys ..."

    #Backup directory tree
    mkdir ~/alastria-keysBackup-$CURRENT_DATE
    mkdir ~/alastria-keysBackup-$CURRENT_DATE/data
    mkdir ~/alastria-keysBackup-$CURRENT_DATE/data/geth
    mkdir ~/alastria-keysBackup-$CURRENT_DATE/data/constellation
    echo "Saving constellation keys ..."
    cp -r ~/alastria/data/constellation/keystore ~/alastria-keysBackup-$CURRENT_DATE/data/constellation
    echo "Saving node keys ..."
    cp -r ~/alastria/data/keystore ~/alastria-keysBackup-$CURRENT_DATE/data
    echo "Saving enode ID ..."
    cp ~/alastria/data/geth/nodekey ~/alastria-keysBackup-$CURRENT_DATE/data/geth/nodekey
fi

if ( [ "full" == "$1" ]); then
    echo "Making a complete backup of your current node..."
    cp -r ~/alastria  ~/alastria-backup-$CURRENT_DATE
    echo "Cleaning unnecessary files..."
    rm -Rf ~/alastria-backup-$CURRENT_DATE/logs/*
    rm -Rf ~/alastria-backup-$CURRENT_DATE/data/geth/chainData
    rm -Rf ~/alastria-backup-$CURRENT_DATE/data/geth/nodes
    rm ~/alastria-backup-$CURRENT_DATE/data/geth/LOCK
    rm ~/alastria-backup-$CURRENT_DATE/data/geth/transactions.rpl
    rm ~/alastria-backup-$CURRENT_DATE/data/geth.ipc
    rm -Rf ~/alastria-backup-$CURRENT_DATE/data/quorum-raft-state
    rm -Rf ~/alastria-backup-$CURRENT_DATE/data/raft-snap
    rm -Rf ~/alastria-backup-$CURRENT_DATE/data/raft-wal
    rm -Rf ~/alastria-backup-$CURRENT_DATE/data/constellation/data
    rm ~/alastria-backup-$CURRENT_DATE/data/constellation/constellation.ipc

fi