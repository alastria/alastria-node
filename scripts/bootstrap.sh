#!/bin/bash


function superuser {
  if ( type "sudo"  > /dev/null 2>&1 )
  then
    sudo $@
  else
    eval $@
  fi
}

function installgo {
  #GOREL="go1.9.5.linux-amd64.tar.gz"
  GOREL="go1.15.2.linux-amd64.tar.gz"
  if ( ! type "go" > /dev/null 2>&1 )
  then
    PATH="$PATH:/usr/local/go/bin"
    echo "Installing GO"    
    wget "https://golang.org/dl/$GOREL" -O /tmp/$GOREL
    pushd /tmp
    tar xvzf $GOREL
    superuser rm -rf /usr/local/go
    superuser mv /tmp/go /usr/local/go
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
  superuser yum clean all
  superuser yum -y update
  
  # Check EPEL repository availability. It is available by default in Fedora and CentOS, but it requires manual
  # installation in RHEL
  EPEL_AVAILABLE=$(superuser yum search epel | grep release || true)
  if [[ -z $EPEL_AVAILABLE ]];then
    echo "EPEL Repository is not available via YUM. Downloading"
    superuser yum -y install wget
    wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -O /tmp/epel-release-latest-7.noarch.rpm
    superuser yum -y install /tmp/epel-release-latest-7.noarch.rpm
  else 
    echo "EPEL repository is available in YUM via distro packages. Adding it as a source for packages"
    superuser yum -y install epel-release
  fi
  
  superuser yum -y update
  echo "Installing Libraries"
  superuser yum -y install gmp-devel gcc gcc-c++ make openssl-devel libdb-devel\
                      ncurses-devel wget nmap-ncat libsodium-devel libdb-devel leveldb-devel bind-utils
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
    superuser cp $constellationrel/constellation-node /usr/local/bin 
    superuser chmod 0755 /usr/local/bin/constellation-node
    superuser rm -rf $constellationrel.tar.xz $constellationrel.tar $constellationrel
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
      superuser ln -s /lib64/libsodium.so /lib64/libsodium.so.18
      superuser ldconfig
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
    #git clone https://github.com/alastria/quorum.git
    git clone https://github.com/ConsenSys/quorum.git
    cd quorum
    #git checkout 775aa2f5a6a52d9d84c85d5ed73521a1ea5b15b3
    #git checkout 30d4d724765a0c82a39db33088a66057896e7c83 #2.2.4
    #git checkout c894c2d70eacf30740d03b53ed2fb39e42641295 #2.2.5
    git checkout 9339be03f9119ee488b05cf087d103da7e68f053 #2.6.0
    make all
    superuser cp build/bin/geth /usr/local/bin
    superuser cp build/bin/bootnode /usr/local/bin
    popd
    rm -rf /tmp/quorum
  fi
}

function debrequired {
  superuser apt-get update && superuser apt-get upgrade -y
  superuser apt-get install -y software-properties-common unzip wget git\
       make gcc libsodium-dev build-essential libdb-dev zlib1g-dev \
       libtinfo-dev sysvbanner psmisc libleveldb-dev\
       libsodium-dev libdb5.3-dev dnsutils
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

  exec "$BASH"

}

function uninstallalastria {
  superuser rm -rf /usr/local/go 2>/dev/null
  superuser rm /usr/local/bin/constellation-node 2>/dev/null
  superuser rm /usr/local/bin/geth 2>/dev/null
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

