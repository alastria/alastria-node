#!/bin/bash
set -u
set -e
TMPFILE="/tmp/$(basename $0).$$.tmp"
tmpfile=$(mktemp /tmp/updatePerm.XXXXXX)
NODE_TYPE="$1"
DESTDIR="$HOME/tmp/data/"
DATADIR="$HOME/alastria-node/data/"

echo "[" > $TMPFILE

if [ "$NODE_TYPE" == "bootnode" ]; then
   cat $DATADIR/boot-nodes.json $DATADIR/validator-nodes.json $DATADIR/regular-nodes.json >> $TMPFILE
 else
   if [ "$NODE_TYPE" == "validator" ]; then
     cat $DATADIR/boot-nodes.json $DATADIR/validator-nodes.json >> $TMPFILE
 else
   if [ "$NODE_TYPE" == "regular" ]; then
     cat $DATADIR/boot-nodes.json >> $TMPFILE
  fi
  fi
fi
cat $TMPFILE | sed '$s/,$//' > $tmpfile
echo "]" >> $tmpfile
#cat $tmpfile
cat $tmpfile > $DESTDIR/static-nodes.json
cp $DESTDIR/static-nodes.json $DESTDIR/permissioned-nodes.json
# echo "Removing temp files ..."
rm $TMPFILE
rm $tmpfile
set +u
set +e
