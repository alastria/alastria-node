#!/bin/bash

set -e

GOREL="go1.7.3.linux-amd64.tar.gz"
PATH="$PATH:/usr/local/go/bin"

rm -Rf /usr/local/go

apt-get update && apt-get install -y

#INSTALACION DE LIBRERIAS
apt-get install -y software-properties-common unzip wget git make gcc libsodium-dev build-essential libdb-dev zlib1g-dev libtinfo-dev sysvbanner wrk psmisc

#INSTALACION ETHEREUM
add-apt-repository -y ppa:ethereum/ethereum && apt-get update && apt-get install -y solc

#INSTALACION CONSTELLATION 0.1.0
wget -q https://github.com/jpmorganchase/constellation/releases/download/v0.1.0/constellation-0.1.0-ubuntu1604.tar.xz 
unxz constellation-0.1.0-ubuntu1604.tar.xz 
tar -xf constellation-0.1.0-ubuntu1604.tar
cp constellation-0.1.0-ubuntu1604/constellation-node /usr/local/bin && chmod 0755 /usr/local/bin/constellation-node
rm -rf constellation-0.1.0-ubuntu1604.tar.xz constellation-0.1.0-ubuntu1604.tar constellation-0.1.0-ubuntu1604

#INSTALACION DE GO
wget -q "https://storage.googleapis.com/golang/${GOREL}"
tar -xvzf "${GOREL}"
mv go /usr/local/go
rm "${GOREL}"

#INSTALACION DE QUORUM
git clone https://github.com/jpmorganchase/quorum.git
cd quorum && git checkout tags/v1.1.0 && make all &&  cp build/bin/geth /usr/local/bin && cp build/bin/bootnode /usr/local/bin

cd ..
rm -rf constellation-0.1.0-ubuntu1604.tar.xz constellation-0.1.0-ubuntu1604.tar constellation-0.1.0-ubuntu1604 quorum

set +e
