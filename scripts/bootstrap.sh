#!/bin/bash

function installgo {
  GOREL="go1.9.5.linux-amd64.tar.gz"
  if ( ! type "go" > /dev/null 2>&1 )
  then
    PATH="$PATH:/usr/local/go/bin"
    echo "Installing GO"    
    wget "https://storage.googleapis.com/golang/$GOREL" -O /tmp/$GOREL
    pushd /tmp
    tar xvzf $GOREL
    sudo rm -rf /usr/local/go
    sudo mv /tmp/go /usr/local/go
    popd
    rm -rf /tmp/go
  else
    V1=$(go version | grep -oP '\d+(?:\.\d+)+')
    V2=$(echo $GOREL | grep -oP '\d+(?:\.\d+)+')
    nV1=$(echo $V1 | sed 's/\.//g')
    nV2=$(echo $V2 | sed 's/\.//g')
    if (( $nV1 >= $nV2 )); then
      echo "Your current version of golang ($V1) is higher than the required to run Alastria nodes ($V2), so we will use it"
    else
      echo "Your version of go is outdated. Installation stopped. This script will install an up-to-date golang runtime if you remove your current version"
      exit
    fi
  fi
}

function rhrequired {
  sudo yum clean all
  sudo yum -y update
  
  # Check EPEL repository availability. It is available by default in Fedora and CentOS, but it requires manual
  # installation in RHEL
  EPEL_AVAILABLE=$(sudo yum search epel | grep release || true)
  if [[ -z $EPEL_AVAILABLE ]];then
    echo "EPEL Repository is not available via YUM. Downloading"
    sudo yum -y install wget
    wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -O /tmp/epel-release-latest-7.noarch.rpm
    sudo yum -y install /tmp/epel-release-latest-7.noarch.rpm
  else 
    echo "EPEL repository is available in YUM via distro packages. Adding it as a source for packages"
    sudo yum -y install epel-release
  fi
  
  sudo yum -y update
  echo "Installing Libraries"
  sudo yum -y install gmp-devel gcc gcc-c++ make openssl-devel libdb-devel\
                      ncurses-devel wget nmap-ncat libsodium-devel libdb-devel leveldb-devel
}

function installconstellation {
  constellationrel="constellation-0.3.2-ubuntu1604"
  if ( ! type "constellation-node" > /dev/null 2>&1 )
  then
    echo "Installing Constellation"
    wget https://github.com/jpmorganchase/constellation/releases/download/v0.3.2/$constellationrel.tar.xz -O /tmp/$constellationrel.tar.xz
    pushd /tmp
    unxz $constellationrel.tar.xz
    tar -xf $constellationrel.tar
    sudo cp $constellationrel/constellation-node /usr/local/bin 
    sudo chmod 0755 /usr/local/bin/constellation-node
    sudo rm -rf $constellationrel.tar.xz $constellationrel.tar $constellationrel
    popd
    fixconstellation
  fi
}

function fixconstellation {
  #It turns out that centos ships libsodium-23 which does not provide a link for libsodium 18
  sodiumrel=$(ldd /usr/local/bin/constellation-node 2>/dev/null | grep libsodium | sed 's/libsodium.so.18 => //' | tr -d '[:space:]')
  if [ $sodiumrel = "notfound" ]
  then
    if [ -f /lib64/libsodium.so ]
    then
      echo "The libsodium package version in the distribution mismatches the one linked in constellation. Symlinking"
      sudo ln -s /lib64/libsodium.so /lib64/libsodium.so.18
      sudo ldconfig
    else
      echo "libsodium requirement in constellation was not satisfied, and a libsodium library was not found to make-do."
      exit
    fi
  fi 
}

function installquorum {
  if ( ! type "geth" > /dev/null 2>&1 )
  then
    echo "Installing QUORUM"
    pushd /tmp
    git clone https://github.com/alastria/quorum.git
    cd quorum
    git checkout 94e1e31eb6a97e08dff4e44a8695dab1252ca3bc
    make all
    sudo cp build/bin/geth /usr/local/bin
    sudo cp build/bin/bootnode /usr/local/bin
    popd
    rm -rf /tmp/quorum
  fi
}

function debrequired {
  sudo apt-get update && sudo apt-get upgrade -y
  sudo apt-get install -y software-properties-common unzip wget git\
       make gcc libsodium-dev build-essential libdb-dev zlib1g-dev \
       libtinfo-dev sysvbanner psmisc libleveldb-dev\
       libsodium-dev libdb5.3-dev
}

function gopath {
# Manage GOROOT variable
  if [[ -z "$GOROOT" ]]; then
    echo "[*] Trying default $GOROOT. If the script fails please run $HOME/alastria-node/bootstrap.sh or configure GOROOT correctly"
    echo 'export GOROOT=/usr/local/go' >> $HOME/.bashrc
    echo 'export GOPATH=$HOME/alastria/workspace' >> $HOME/.bashrc
    echo 'export PATH=$GOROOT/bin:$GOPATH/bin:$PATH' >> $HOME/.bashrc
    export GOROOT=/usr/local/go
    export GOPATH=$HOME/alastria/workspace
    export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

    echo "[*] GOROOT = $GOROOT, GOPATH = $GOPATH"

    mkdir -p "$GOPATH"/{bin,src}
  fi

  source $HOME/.bashrc

}

function uninstallalastria {
  sudo rm -rf /usr/local/go
  sudo rm /usr/local/bin/constellation-node
  sudo rm /usr/local/bin/geth
  rm -rf /tmp/* 2>/dev/null
}

function installalastria {
  set -e
  OS=$(cat /etc/os-release | grep "^ID=" | sed 's/ID=//g' | sed 's\"\\g')
  if [ $OS = "centos" ] || [ $OS = "rhel" ]
  then
    rhrequired
  elif [ $OS = "ubuntu" ];then
    debrequired
  else
    echo 'This operating system is not yet supported'
    exit
  fi
  
  installgo
  installconstellation
  installquorum
  gopath
  
  set +e
}

if [ "$EUID" == "0" ]
then
  echo 'Please run this script as a regular user. We will ask for administration credentials only when required'.
fi  

if ( [ "uninstall" == "$1" ] )
then
  uninstallalastria
elif ( [ "reinstall" == "$1" ] )
then
   uninstallalastria
   installalastria
else
  installalastria
fi

