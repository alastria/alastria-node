#!/bin/bash
set -u
set -e

TMPFILE="/tmp/$(basename $0).$$.tmp"

if [ -z $1 ]; then
	echo "ERROR: nodetype not provided"
	exit 1
fi

NODE_TYPE="$1"
DESTDIR="$HOME/alastria/data/"
DATADIR="$HOME/alastria-node/data/"

echo "Getting current nodes..."

for i in boot-nodes.json validator-nodes.json regular-nodes.json ; do
	curl https://raw.githubusercontent.com/alastria/alastria-node/testnet2/data/${i} > ${DATADIR}/${i}
done

echo "Parsing correct node database..."

case $NODE_TYPE in
	"bootnode")
		cat $DATADIR/boot-nodes.json $DATADIR/validator-nodes.json $DATADIR/regular-nodes.json >> $TMPFILE
	;;
	"validator")
		cat $DATADIR/boot-nodes.json $DATADIR/validator-nodes.json >> $TMPFILE
	;;
	"general")
		cat $DATADIR/boot-nodes.json >> $TMPFILE
	;;
	*)
		echo "ERROR: nodetype not recognized"
		exit 1
	;;
esac

sed -e 's/^/[\n/' -i $TMPFILE
sed -e 's/,$/]/' -i $TMPFILE

cat $TMPFILE > $DESTDIR/static-nodes.json
cat $TMPFILE > $DESTDIR/permissioned-nodes.json

echo "Removing temp file..."
rm $TMPFILE

set +u
set +e
