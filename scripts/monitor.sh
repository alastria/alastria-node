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

    # if hash glide 2>/dev/null; then
    #     echo "[*] Installing glide"
    #     curl https://glide.sh/get | sh
    # fi


    echo "[*] Removing previous versions"
    rm -rf ~/alastria/monitor
    mkdir ~/alastria/monitor
    echo "[*] Cloning monitor's repository"
    cd ~/alastria/monitor
    export GOPATH=$(pwd)
    export PATH=$GOPATH/bin:$PATH
    go get "github.com/robfig/cron"
    echo "[*] Installing glide"
    curl https://glide.sh/get | sh
    mkdir ~/alastria/monitor/src/github.com/alastria
    cd ~/alastria/monitor/src/github.com/alastria
    git clone "https://github.com/alastria/monitor"

    cd ~/alastria/monitor/src/github.com/alastria/monitor        
    git checkout tags/v0.0.1-alpha
    
    echo "[*] Installing dependencies"
    glide install
    echo "[*] Building the monitor"
    go build
fi

if ( [ "start" == "$1" ]); then 
    cd ~/alastria/monitor/src/github.com/alastria/monitor
    echo "[*] Starting monitor"
    ~/alastria/monitor/src/github.com/alastria/monitor/monitor &
fi

export GOPATH=$GOPATHOLD
export PATH=$GOPATH/bin:$PATH

set +u
set +e
