#!/bin/bash
set -u
set -e

MESSAGE='Usage: monitor <mode>
    mode: build | start '

if ( [ $# -ne 1 ] ); then
    echo "$MESSAGE"
    exit
fi

if [ -z "$GOROOT" ]; then
    echo "Please set your $GOROOT or run ~/alastria"
    exit 1
fi

GOPATHOLD="$GOPATH"


if ( [ "build" == "$1" ]); then 
    if hash gdate 2>/dev/null; then
        echo "[*] Installing glide"
        curl https://glide.sh/get | sh
    fi

    echo "[*] Cloning monitor's repository"
    rm -rf ~/alastria/monitor
    mkdir ~/alastria/monitor
    cd ~/alastria/monitor
    export GOPATH=$(pwd)
    export PATH=$GOPATH/bin:$PATH
    go get "github.com/alastria/monitor"

    cd ~/alastria/monitor/src/github.com/alastria/monitor
    # git checkout dev/arochaga
        
   
    echo "[*] Installing dependencies"
    glide install
    echo "[*] Building the monitor"
    go build
fi

if ( [ "start" == "$1" ]); then 
    cd ~/alastria/monitor/src/github.com/alastria/monitor
    echo "[*] Starting monitor"
    ~/alastria/monitor/src/github.com/alastria/monitor &
fi

export GOPATH=$GOPATHOLD
export PATH=$GOPATH/bin:$PATH

set +u
set +e
