#!/bin/bash
set -e

MESSAGE='Usage: init <mode> <node-type> <node-name>
    mode: CURRENT_HOST_IP | auto | backup
    node-type: validator | general | bootnode
    node-name: NODE_NAME (example: Alastria)'

if ( [ $# -ne 3 ] ); then
    echo "$MESSAGE"
    exit
fi

VALIDATOR0_HOST_IP="$(dig +short validator0.telsius.alastria.io @resolver1.opendns.com 2>/dev/null || curl -s --retry 2 icanhazip.com)"
CURRENT_HOST_IP="$1"
NODE_TYPE="$2"
NODE_NAME="$3"
ACCOUNT_PASSWORD='Passw0rd'


if ( [ "auto" == "$1" -o "backup" == "$1" ]); then
    echo "Autodiscovering public host IP ..."
    CURRENT_HOST_IP="$(dig +short myip.opendns.com @resolver1.opendns.com 2>/dev/null || curl -s --retry 2 icanhazip.com)"
    echo "Public host IP found: $CURRENT_HOST_IP"
fi

if ( [ "dockerfile" == "$1" ]); then
    echo "Getting IP from environmental variable ..."
    CURRENT_HOST_IP=$HOST_IP
    echo "Public host IP found: $CURRENT_HOST_IP"
fi

if ( [ "backup" == "$1" ]); then
    echo "Backing up current node keys ..."
    #Backup directory tree
    mkdir ~/alastria-keysBackup
    mkdir ~/alastria-keysBackup/data
    mkdir ~/alastria-keysBackup/data/geth
    mkdir ~/alastria-keysBackup/data/constellation
    echo "Saving constellation keys ..."
    cp -r ~/alastria/data/constellation/keystore ~/alastria-keysBackup/data/constellation/
    echo "Saving node keys ..."
    cp -r ~/alastria/data/keystore ~/alastria-keysBackup/data
    echo "Saving enode ID ..."
    cp ~/alastria/data/geth/nodekey ~/alastria-keysBackup/data/geth/nodekey
fi

PWD="$(pwd)"
CONSTELLATION_NODES=$(cat ../data/constellation-nodes.json)

update_constellation_nodes() {
    NODE_IP="$1"
    CONSTELLATION_PORT="$2"

    URL=",
    \"https://$NODE_IP:$CONSTELLATION_PORT/\"
]"
    CONSTELLATION_NODES=${CONSTELLATION_NODES::-2}
    CONSTELLATION_NODES="$CONSTELLATION_NODES$URL"
    echo "$CONSTELLATION_NODES" > ~/alastria-node/data/constellation-nodes.json
}

update_nodes_list() {
    echo "Selected $NODE_TYPE node..."
    echo "Updating permissioned nodes..."

    # Deleting obsolete records of the same node
    sed -i "/$CURRENT_HOST_IP/d" ~/alastria-node/data/*-nodes.json
    
    BOOT_NODES=$(cat ~/alastria-node/data/boot-nodes.json)
    REGULAR_NODES=$(cat ~/alastria-node/data/regular-nodes.json)
    VALIDATOR_NODES=$(cat ~/alastria-node/data/validator-nodes.json)

    ENODE="
 \"$1\","
 
   if ( [ "validator" == "$NODE_TYPE" ]); then
        VALIDATOR_NODES="$VALIDATOR_NODES$ENODE"
        echo "$VALIDATOR_NODES" > ~/alastria-node/data/validator-nodes.json
    else
      if ( [ "general" == "$NODE_TYPE" ]); then
          REGULAR_NODES="$REGULAR_NODES$ENODE"
          echo "$REGULAR_NODES" > ~/alastria-node/data/regular-nodes.json
        else
          if ( [ "bootnode" == "$NODE_TYPE" ]); then
              BOOT_NODES="$BOOT_NODES$ENODE"
              echo "$BOOT_NODES" > ~/alastria-node/data/boot-nodes.json
         fi 
       fi
    fi

}


generate_conf() {
   #define parameters which are passed in.
   NODE_IP="$1"
   CONSTELLATION_PORT="$2"
   OTHER_NODES="$3"
   PWD="$4"

   #define the template.
   cat  << EOF
# Externally accessible URL for this node (this is what's advertised)
url = "https://$NODE_IP:$CONSTELLATION_PORT/"

# Port to listen on for the public API
port = $CONSTELLATION_PORT

# Socket file to use for the private API / IPC
socket = "$PWD/alastria/data/constellation/constellation.ipc"

# Initial (not necessarily complete) list of other nodes in the network.
# Constellation will automatically connect to other nodes not in this list
# that are advertised by the nodes below, thus these can be considered the
# "boot nodes."
othernodes = $OTHER_NODES

# The set of public keys this node will host
publickeys = ["$PWD/alastria/data/constellation/keystore/node.pub"]

# The corresponding set of private keys
privatekeys = ["$PWD/alastria/data/constellation/keystore/node.key"]

# Optional file containing the passwords to unlock the given privatekeys
# (one password per line -- add an empty line if one key isn't locked.)
passwords = "$PWD/alastria/data/passwords.txt"

# Where to store payloads and related information
storage = "$PWD/alastria/data/constellation/data"

# Verbosity level (each level includes all prior levels)
#   - 0: Only fatal errors
#   - 1: Warnings
#   - 2: Informational messages
#   - 3: Debug messages
verbosity = 2

EOF
}

install_monitor() {
    if [[ ! -z "$GOPATH"/src/github.com/alastria/monitor  ]]; then
        echo "Installing monitor"
        ~/alastria-node/scripts/monitor.sh build
    fi
}

echo "[*] Cleaning up temporary data directories."
rm -rf ~/alastria/data
rm -rf ~/alastria/logs/quorum*
mkdir -p ~/alastria/data/{geth,constellation}
mkdir -p ~/alastria/data/constellation/{data,keystore}
mkdir -p ~/alastria/logs

install_monitor

echo "$NODE_NAME" > ~/alastria/data/IDENTITY
echo "$NODE_TYPE" > ~/alastria/data/NODE_TYPE

# Creamos el fichero de passwords con la contraseña de las cuentas
echo "Passw0rd" > ~/alastria/data/passwords.txt

echo "[*] Initializing quorum"
geth --datadir ~/alastria/data init ~/alastria-node/data/genesis.json
cd ~/alastria/data/geth
bootnode -genkey nodekey
ENODE_KEY=$(bootnode -nodekey nodekey -writeaddress)
if [ ! -f ~/alastria-node/data/keys/data/geth/nodekey ]; then
    echo "[*] creating dir if not created and set nodekey"
    mkdir -p ~/alastria-node/data/keys/data/geth
    cp nodekey ~/alastria-node/data/keys/data/geth/nodekey
fi


if ( [ "backup" == "$1" ]); then
    ENODE_KEY=$(bootnode -nodekey ~/alastria-keysBackup/data/geth/nodekey -writeaddress)
fi

if ( [ "dockerfile" == "$1" ]); then
    ENODE_KEY=$(bootnode -nodekey ~/alastria-node/data/keys/data/geth/nodekey -writeaddress)
fi

echo "ENODE -> 'enode://${ENODE_KEY}@${CURRENT_HOST_IP}:21000?discport=0'"
if ( [ "backup" != "$1" ]); then
    update_nodes_list "enode://${ENODE_KEY}@${CURRENT_HOST_IP}:21000?discport=0"
fi
cd ~
# IP for the inicital validator on network
~/alastria-node/scripts/updatePerm.sh "$NODE_TYPE"

echo "$CURRENT_HOST_IP" > ~/alastria/data/CURRENT_HOST
echo "$VALIDATOR0_HOST_IP" > ~/alastria/data/VALIDATOR_HOST
if [[ "$CURRENT_HOST_IP" == "$VALIDATOR0_HOST_IP" ]]; then
    echo "e7889a64e5ec8c28830a1c8fc620810f086342cd511d708ee2c4420231904d18" > ~/alastria/data/nodekey
fi


if ( [ "general" == "$NODE_TYPE" ]); then
    # echo "     Por favor, introduzca como contraseña 'Passw0rd'."
    echo  "     Definida contraseña por defecto para cuenta principal como: $ACCOUNT_PASSWORD."
    echo $ACCOUNT_PASSWORD > ./account_pass
    # Only create keystore folder on general node.
    mkdir -p ~/alastria/data/keystore
    geth --datadir ~/alastria/data --password ./account_pass account new
    rm ./account_pass

    echo "[*] Initializing Constellation node."

    if ( [ "backup" != "$1" ]); then
        update_constellation_nodes "${CURRENT_HOST_IP}" "9000"
        #generate_conf "${CURRENT_HOST_IP}" "9000" "$CONSTELLATION_NODES" "${PWD}" > ~/alastria/data/constellation/constellation.conf
    fi

    generate_conf "${CURRENT_HOST_IP}" "9000" "$CONSTELLATION_NODES" "${PWD}" > ~/alastria/data/constellation/constellation.conf
    cd ~/alastria/data/constellation/keystore
    cat ~/alastria/data/passwords.txt | constellation-node --generatekeys=node
    if [ ! -f ~/alastria-node/data/keys/data/constellation/keystore ]; then
        echo "[*] creating dir if not created, and set keystore"
        mkdir -p ~/alastria-node/data/keys/data/constellation
        cp -rf . ~/alastria-node/data/keys/data/constellation/keystore
        cp -rf  ~/alastria/data/keystore ~/alastria-node/data/keys/data/
    fi

    echo "______"
    cd ~
fi

if ( [ "backup" == "$1" ]); then
    echo "Recovering keys from backup ..."
    rm -rf ~/alastria/data/constellation/keystore
    rm -rf ~/alastria/data/keystore
    rm ~/alastria/data/geth/nodekey

    echo "Recovering constellation keys ..."
    cp -rf ~/alastria-keysBackup/data/constellation/keystore ~/alastria/data/constellation/
    echo "Recovering node keys ..."
    cp -rf ~/alastria-keysBackup/data/keystore ~/alastria/data/
    echo "Recovering enode ID ..."
    cp ~/alastria-keysBackup/data/geth/nodekey ~/alastria/data/geth/nodekey
    echo "Cleaning backup files ..."
    rm -rf ~/alastria-keysBackup
fi

if ( [ "dockerfile" == "$1" ]); then
    echo "Recovering keys saved in the repository ..."
    rm -rf ~/alastria/data/constellation/keystore
    rm -rf ~/alastria/data/keystore
    rm ~/alastria/data/geth/nodekey

    echo "Recovering constellation keys ..."
    cp -rf ~/alastria-node/data/keys/data/constellation/keystore ~/alastria/data/constellation/
    echo "Recovering node keys ..."
    cp -rf ~/alastria-node/data/keys/data/keystore ~/alastria/data/
    echo "Recovering enode ID ..."
    cp ~/alastria-node/data/keys/data/geth/nodekey ~/alastria/data/geth/nodekey

fi

if ( [ "validator" == "$NODE_TYPE" ]); then
    rm -rf ~/alastria/data/keystore
fi

echo "[*] Initialization was completed successfully."
echo " "
echo "      Update DIRECTORY_REGULAR.md, DIRECTORY_VALIDATOR.md or DIRECTORY_BOOTNODES.md from alastria-node repository and send a Pull Request."
echo "      Don't forget the .json files in data folder!."
echo " "

set +u
set +e
