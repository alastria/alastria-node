#!/bin/bash
set -u
set -e

if [ $# -ne 1 ]; then
	echo "ERROR: illegal number of parameters"
	exit 1
fi

if [ -z $1 ]; then
	echo "ERROR: nodetype not provided"
	exit 1
fi

NODE_TYPE="$1"

TMPFILE=$(mktemp /tmp/updatePerm.XXXXXX)
DESTDIR="$HOME/alastria/data/"
DATADIR="/tmp/"

echo "Getting current nodes..."

for i in boot-nodes.json validator-nodes.json regular-nodes.json ; do
	wget -q -O ${DATADIR}/${i} https://raw.githubusercontent.com/alastria/alastria-node/testnet2/data/${i} 
	echo "Getting ${DATADIR}/${i} ..."
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

sed -e '1s/^/[\n/' -i $TMPFILE
sed -e '$s/,$/\n]/' -i $TMPFILE

cat $TMPFILE > $DESTDIR/static-nodes.json
cat $TMPFILE > $DESTDIR/permissioned-nodes.json
cat $TMPFILE

echo "Removing temp file..."
rm $TMPFILE

echo "*** *** *** *** *** *** *** *** *** *** "
echo "*** Remember restart geth process *** "
echo "*** *** *** *** *** *** *** *** *** *** "

set +u
set +e
