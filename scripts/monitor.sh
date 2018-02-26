#!/bin/bash

MESSAGE='Usage: monitor <mode>
    mode: build | start | version | latest'

if ( [ $# -ne 1 ] ); then
    echo "$MESSAGE"
    exit
fi

_TIME=$(date +%Y%m%d%H%M%S)

# Optional way of handling $GOROOT
# if [ -z "$GOROOT" ]; then
#     echo "Please set your $GOROOT or run $HOME/alastria/bootstrap.sh"
#     exit 1
# fi

if [[ -z "$GOROOT" ]]; then
    echo "[*] Trying default $GOROOT. If the script fails please run $HOME/alastria-node/bootstrap.sh or configure GOROOT correctly"
    export GOROOT=/usr/local/go
    export GOPATH=$HOME/alastria/workspace
    export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

    mkdir -p "$GOPATH"/bin
    mkdir -p "$GOPATH"/src
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
    rm -rf "$GOPATH"/src/github.com/alastria/monitor
    mkdir -p "$GOPATH"/src/github.com/alastria

    echo "[*] Cloning monitor's repository"
    cd "$GOPATH"
    mkdir "$GOPATH"/bin

    echo "[*] Installing glide"
    curl https://glide.sh/get | sh
    go get -d github.com/alastria/monitor
    cd "$GOPATH"/src/github.com/alastria
    
    cd "$GOPATH"/src/github.com/alastria/monitor
    LATEST_TAG=`git describe --tags \`git rev-list --tags --max-count=1\``
    echo "LATESTTAG: $LATEST_TAG"       
    git checkout tags/$LATEST_TAG
    
    echo "[*] Installing dependencies"
    go get -fix -t -u -v github.com/astaxie/beego
    go get -fix -t -u -v github.com/beego/bee

    glide install

    echo "[*] Building the monitor"
    bee pack 
    tar -zxvf monitor.tar.gz monitor
    rm -Rf monitor.tar.gz
fi

if ( [ "start" == "$1" ]); then 
    cd $GOPATH/src/github.com/alastria/monitor
    echo "[*] Starting monitor"
    #nohup $GOPATH/src/github.com/alastria/monitor/monitor >> $HOME/alastria/logs/monitor_"${_TIME}".log &
    nohup bee run -vendor=true -downdoc=true -gendoc=true >> $HOME/alastria/logs/monitor_"${_TIME}".log &
fi

if ( [ "latest" == "$1" ]); then 
    cd $GOPATH/src/github.com/alastria/monitor
    git describe --tags `git rev-list --tags --max-count=1` # gets tags across all branches, not just the current branch
fi

if ( [ "version" == "$1" ]); then 
    cd $GOPATH/src/github.com/alastria/monitor
    git tag
fi

if ( [ "update" == "$1" ]); then
    cd $GOPATH/src/github.com/alastria/monitor
    git pull
    git checkout "$(git describe --tags `git rev-list --tags --max-count=1`)"
    glide up
fi

if [[ ! -z "$GOPATHCHANGED" ]]; then
    export GOPATH=$GOPATHOLD
    export PATH=$GOPATH/bin:$PATH
fi
