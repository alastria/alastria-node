#!/bin/bash
set -u
#set -e
TMPFILE="/tmp/$(basename $0).$$.tmp"
tmpfile=$(mktemp /tmp/updatePerm.XXXXXX)
NODE_TYPE="$1"
DESTDIR="$HOME/alastria/data/"
DATADIR="$HOME/alastria-node/data/"

echo "[" > $TMPFILE

if [ "$NODE_TYPE" == "bootnode" ]; then
   cat $DATADIR/boot-nodes.json $DATADIR/validator-nodes.json $DATADIR/regular-nodes.json >> $TMPFILE
 else
   if [ "$NODE_TYPE" == "validator" ]; then
     cat $DATADIR/boot-nodes.json $DATADIR/validator-nodes.json >> $TMPFILE
 else
   if [ "$NODE_TYPE" == "general" ]; then
     cat $DATADIR/boot-nodes.json >> $TMPFILE
  fi
  fi
fi
cat $TMPFILE | sed '$s/,$//' > $tmpfile
echo "]" >> $tmpfile
#cat $tmpfile
python -c "import json.tool" 2> /dev/null #compruebo si puedo validar el json antes de copiarlo
if [ $? -eq 0 ]; then
        OK=`cat $tmpfile | python -m json.tool  >> /dev/null 2>/dev/null || echo "0"`
        if [ "$OK" == "0" ]; then
                echo "json incorrecto"
        else
                cat $tmpfile > $DESTDIR/static-nodes.json
                cp $DESTDIR/static-nodes.json $DESTDIR/permissioned-nodes.json
        fi
else
        echo "sin json.tool"
        cat $tmpfile > $DESTDIR/static-nodes.json
        cp $DESTDIR/static-nodes.json $DESTDIR/permissioned-nodes.json
fi
# echo "Removing temp files ..."
rm $TMPFILE
rm $tmpfile
set +u
#set +e
