#!/bin/bash

set -e

GOREL="go1.7.3.linux-amd64.tar.gz"

#Do not mess with Go instalations
if ! type "go" > /dev/null; then
  #INSTALACION DE GO
  PATH="$PATH:/usr/local/go/bin"
  echo "Installing GO"
  wget -q "https://storage.googleapis.com/golang/${GOREL}"
  tar -xvzf "${GOREL}"
  mv go /usr/local/go
  sudo rm "${GOREL}"
else
  V1=$(go version | grep -oP '\d+(?:\.\d+)+')
  V2=$(echo $GOREL | grep -oP '\d+(?:\.\d+)+')
  nV1=$(echo $V1 | sed 's/\.//g')
  nV2=$(echo $V2 | sed 's/\.//g')
  if (( $nV1 >= $nV2 )); then
     echo "Using your own version of Go"
  else
     echo "Your version of go is smaller than required"
     exit
  fi
fi

sudo apt-get update && sudo apt-get install -y

#INSTALACION DE LIBRERIAS
sudo apt-get install -y software-properties-common unzip wget git make gcc libsodium-dev build-essential libdb-dev zlib1g-dev libtinfo-dev sysvbanner wrk psmisc

#INSTALACION ETHEREUM
sudo add-apt-repository -y ppa:ethereum/ethereum && sudo apt-get update && sudo apt-get install -y solc

#INSTALACION CONSTELLATION 0.1.0
wget -q https://github.com/jpmorganchase/constellation/releases/download/v0.1.0/constellation-0.1.0-ubuntu1604.tar.xz 
unxz constellation-0.1.0-ubuntu1604.tar.xz 
tar -xf constellation-0.1.0-ubuntu1604.tar
sudo cp constellation-0.1.0-ubuntu1604/constellation-node /usr/local/bin && sudo chmod 0755 /usr/local/bin/constellation-node
sudo rm -rf constellation-0.1.0-ubuntu1604.tar.xz constellation-0.1.0-ubuntu1604.tar constellation-0.1.0-ubuntu1604

#INSTALACION DE QUORUM
git clone https://github.com/jpmorganchase/quorum.git
cd quorum && git checkout tags/v1.1.0 && make all &&  cp build/bin/geth /usr/local/bin && cp build/bin/bootnode /usr/local/bin

cd ..
sudo rm -rf constellation-0.1.0-ubuntu1604.tar.xz constellation-0.1.0-ubuntu1604.tar constellation-0.1.0-ubuntu1604 quorum

set +e
