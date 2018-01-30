#!/bin/bash

MESSAGE='Usage: monitor <mode>
    mode: build | start '

if ( [ $# -ne 1 ] ); then
    echo "$MESSAGE"
    exit
fi

# Optional way of handling $GOROOT
# if [ -z "$GOROOT" ]; then
#     echo "Please set your $GOROOT or run ~/alastria/bootstrap.sh"
#     exit 1
# fi

if [[ -z "$GOROOT" ]]; then
    echo "[*] Trying default $GOROOT. If the script fails please run ~/alastria-node/bootstrap.sh or configure GOROOT correctly"
    export GOROOT=/usr/local/go
    export PATH=$PATH:$GOROOT/bin
fi

if [[ ! -z "$GOPATH" ]]; then
    GOPATHCHANGED="true"
    GOPATHOLD="$GOPATH"
fi


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
    echo "Go PATH: $GOPATH"
    echo "GOROOT: $GOROOT"
    export PATH=$GOPATH/bin:$PATH
    mkdir ~/alastria/monitor/bin
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

if ( [ "latest" == "$1" ]); then 
    cd ~/alastria/monitor/src/github.com/alastria/monitor
    git describe --tags `git rev-list --tags --max-count=1` # gets tags across all branches, not just the current branch
fi

if ( [ "version" == "$1" ]); then 
    cd ~/alastria/monitor/src/github.com/alastria/monitor
    git tag
fi

if [[ ! -z "$GOPATHCHANGED" ]]; then
    export GOPATH=$GOPATHOLD
    export PATH=$GOPATH/bin:$PATH
fi
