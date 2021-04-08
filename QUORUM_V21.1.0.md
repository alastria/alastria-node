## MIGRATE a REGULAR NODE to Quorum v21.1.0 under Ubuntu-20

This guide assumes you already have a **regular node** in **Alastria RedT (GoQuorum)** with an old version of geth (e.g. 1.8.x), and wish to install a new node preserving the existing enode address (it might be that your new node will have a new IP address, in which case you will have to update Alastria's repo anyway). 

If this is your first time and you don't have a node yet, you can still follow this tutorial but you need to generate a new **nodekey** and consequently a new **e-node** address.

If you need to update your e-node address, please submit an *issue* to repository https://github.com/alastria/nodes-redt telling which is your e-node and the organisation you belong to.

Beware that bumping geth version from 1.8.x to 1.9.x means having at least **8 Gigabytes of RAM** available for the geth process in a regular node.

So we assume these instructions are going to be executed on a newly installed Ubuntu 20.x VPS or bare-metal server.

The VPS might be a node in a public cloud like AWS, Azure, DigitalOcean, etc ... 

It could be a VPS on-premise under any virtualization e.g. Openstack KVM, Xen, Virtualbox, VMWare, Hyper-V etc. or even Ubuntu-20 installed on top of bare-metal.

If you want to try this recipe under Docker, you need to build your Dockerfile.

If your choice is Ansible, you will have to rewrite these instructions into an *ansible playbook*.

This installation is going to use a user different than root , namely **alastria**:

````
useradd alastria -d /home/alastria
mkdir /home/alastria
chown alastria:alastria /home/alastria
````

You must have the **nodekey** file contents from your current node available in order to proceed. If you don't , you will have to generate it with the **bootnode** util:

````
cd /home/alastria/data/geth
bootnode -genkey nodekey
````

If your current installation is using Docker, you will likely find the **nodekey** file under */root/alastria/data/geth*

So far you have */home/alastria/data/geth/nodekey* in place, wether by newly generating it or by recovering it from a previous installation.

If you had a keystore in your old node, you will have to copy it back here to the new node too.


### Build geth and other binaries

If we only needed geth, we could just retrieve Consensys's official distribution tarball at 
geth_v21.1.0_linux_amd64.tar.gz https://bintray.com/quorumengineering/quorum/download_file?file_path=v21.1.0/geth_v21.1.0_linux_amd64.tar.gz

But we need also the **bootnode** binary , and therefore we're going to build all binaries under Ubuntu-20.

First retrieve golang 1.15.2 which is the version used by Consensys to compile its binary distribution.

````
apt install golang build-essential
cd /usr/local/src
wget https://golang.org/dl/go1.15.2.linux-amd64.tar.gz
tar xvfz go1.15.2.linux-amd64.tar.gz
/bin/rm -f /usr/bin/go
ln -s /usr/local/src/go/bin/go /usr/bin/go
go version
>go version go1.15.2 linux/amd64
````

Now retrieve Consensys's repo, compile and build the binaries.

Beware that the checkout hash corresponds to the 21.1.0 Tag, namely 
https://github.com/ConsenSys/quorum/releases/tag/v21.1.0 , and from there you get the commit hash:

https://github.com/ConsenSys/quorum/commit/a21e1d44cb4da8eaaf66dedb3ae16118db0cb7ef

````
cd /usr/local/src
git clone https://github.com/ConsenSys/quorum.git
git checkout a21e1d44cb4da8eaaf66dedb3ae16118db0cb7ef
make all
````

This will generate all these binaries under build/bin
````
abigen*  bootnode*  checkpoint-admin*  clef*  devp2p*  ethkey*  evm*  examples*  faucet*  geth*  p2psim*  puppeth*  rlpdump*  wnode*
````

Move the needed binaries to */usr/local/bin* and make them *executable* under user and group *alastria*:

````
mv build/bin/geth /usr/local/bin
md build/bin/bootnode /usr/local/bin
chmod +x /usr/local/bin/geth
chmod +x /usr/local/bin/bootnode
chown alastria:alastria /usr/local/bin/geth /usr/local/bin/bootnode
````

To make sure you have the right geth, just execute **geth version**:
````
Geth
Version: 1.9.7-stable
Git Commit: a21e1d44cb4da8eaaf66dedb3ae16118db0cb7ef
Quorum Version: 21.1.0
Architecture: amd64
Protocol Versions: [64 63]
Network Id: 1337
Go Version: go1.15.2
Operating System: linux
GOPATH=
GOROOT=/usr/local/src/go
````

### Initialize Alastria RedT chain

Retrieve Alastria RedT's **genesis** file and initialize the chain with it:

````
su - alastria
wget -q -O /home/alastria/genesis.json https://raw.githubusercontent.com/alastria/alastria-node/testnet2/data/genesis.json
geth --datadir /home/alastria/data init /home/alastria/genesis.json
````

We are assuming that the **nodekey** file you have from your previous node is located under /home/alastria/data/geth

You can generate the enode in a small shell script and make sure it's the same public key than before, for instance /usr/local/bin/enode

````
#!/bin/bash

HOST_IP=$(curl ipecho.net/plain)
ENODE_KEY=$(bootnode -nodekey /home/alastria/data/geth/nodekey -writeaddress)
ENODE="enode://${ENODE_KEY}@${CURRENT_HOST_IP}:21000?discport=0"
echo $ENODE
````

The difference between this ENODE and your ongoing ENODE is that the IP address could be a different one. If you're installing under the old IP address, you don't need to update Alastria's repository.

Now the easiest way to bring up geth every time your machine boots up is by creating an /etc/rc.local file with exec permissions, and contents like this (NODENAME is the name under which your node is visible to the rest of the network, e.g. REG_Planisys_Telsius_8_16_01, and ALASTRIA_INFLUX is the password provided to push metrics into InfluxDB).

### Start on Boot

````
#!/bin/bash

cd /home/alastria/data
wget https://raw.githubusercontent.com/alastria/alastria-node/testnet2/data/regular-nodes.json
wget https://raw.githubusercontent.com/alastria/alastria-node/testnet2/data/boot-nodes.json

cd /home/alastria

nohup env PRIVATE_CONFIG=ignore su alastria -c "/usr/local/bin/geth --datadir /home/alastria/data --networkid 83584648538 \
  --identity NODENAME --permissioned -rpc --rpcaddr 127.0.0.1 \
  --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul \
  --rpcport 22000 --port 21000 --istanbul.requesttimeout 10000 --port 21000 \
  --ethstats NODENAME:bb98a0b6442386d0cdf8a31b267892c1@netstats.telsius.alastria.io:80 \
  --targetgaslimit 8000000 --syncmode fast --gcmode full --vmodule consensus/istanbul/core/core.go=5 \
  --nodiscover --metrics --metrics.expensive  \
  --pprof --pprofaddr 0.0.0.0 --pprofport 9545 \
  --metrics.influxdb --metrics.influxdb.endpoint http://geth-metrics.planisys.net:8086 \
  --metrics.influxdb.database alastria --metrics.influxdb.username alastriausr \
  --metrics.influxdb.password ALASTRIA_INFLUX \
  --metrics.influxdb.tags host==NODENAME \
  --verbosity 5 --cache 10 --nousb --maxpeers 200" 2>&1 > /home/alastria/logs/quorum.log &
  
/usr/bin/pidof geth > /var/run/geth.pid

````

You can now reboot your server. It will execute /etc/rc.local bash script as the last stage of initialization, it will first retrieve the json file containing the bootnodes and then run geth in background. It will also store the process-id of geth into */var/run/geth.pid* which you will later need for auto-restart by **monit**


### Meaning of geth options

This way, you will be performing **fast-sync** until your node is close to the head of the blockchain, and it will then turn into **full-sync** automatically, that is, it will execute all transactions. It will take around 36 hours as of the time of this writing to be fully synchronized at the chain height.

Your node will be exporting metrics to a local **prometheus** node exporter under port 9545, so Alastria's prometheus server will scrape its metrics (this is done under the HTTP protocol, in case you want to open up the port for external scraping).

On the other hand, the node pushes metrics to Alastria's **InfluxDB** server, so you might need to permit outgoing TCP connections to external port 8086.

In order for the blockchain protocol to work , you need to open **port 21000 bidirectionally**.

Under this configuration, **RPC** will be restricted to localhost under port 22000.

The **ethstats** option implies that your geth will be opening a websockets connection to a remote server to send statistics data. This way, your node will be listed at *http://netstats.telsius.alastria.io* ethstats page.

If you wish to access RPC remotely there are mainly two options:
* use an nginx proxy with Alastria's configuration called **access-point** and whitelist the IP addresses where you will be invoking RPC endpoints from (take a look at https://github.com/alastria/alastria-access-point)
* build an API within the node, preferrably asynchronous e.g. Async Python under FastAPI and hypercorn with credentials and JWT (*Json Web Tokens*) to interact with your external app

At this point, you will have **geth** logging in debug mode to /home/alastria/logs/quorum.log which might grow very fast to more than a couple of gigabytes per week.

The chain resides under */home/alastria/data/geth/chaindata* and it is by the time of this writing (april 2021) 67G big.  Under the chaindata directory there is a subdirectory called *ancient* that holds 57G of the 67G of the chain storage.

### Auto Restart

The startup method of rc.local is not as powerful as a systemd unit, which we will skip for the time being. Instead we're going to add **monit** to bring geth back up in case it panics.

````
apt add monit
````

Then put this contents into */etc/monit/monitrc*

````
set daemon  60
set logfile syslog facility log_daemon

check process geth with pidfile /var/run/geth.pid
    start program = "/bin/bash /etc/rc.local"
    stop program = "kill $(cat /var/run/geth.pid)"
	if failed port 22000 for 2 cycles then restart
````

and restart the service with

````
systemctl restart monit.service
````

In order to be sure geth is up and running, take a look at the logs

````
tail -f /home/alastria/logs/quorum.log
````

### Log rotation

In order to keep your logs under control so they don't fill up your disk, install a module into the **logrotate** system.

Under */etc/logrotate.d/* create the file *geth* with these contents:

````
/home/alastria/logs/quorum.log {
 rotate 7
 daily
 compress
 postrotate
   kill -1 $(cat /var/run/geth.pid)
 endscript
 create 0664 alastria alastria
 missingok
 delaycompress
 copytruncate
}
````

### Test RPC

First you might want to install **jq** to view nicely formatted jsons.

````
apt install jq
````

This call lets you check the **geth version**:

````
curl -X POST -H "Content-Type: application/json"  --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[], "id":1}' \
http://127.0.0.1:22000 2>/dev/null | jq
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "Geth/REG_Planisys_Telsius_8_16_01/v1.9.7-stable-a21e1d44(quorum-v21.1.0)/linux-amd64/go1.15.2"
}
````


To check which peers you're connected to , you would need to issue 

````
curl -X POST -H "Content-Type: application/json"  --data '{"jsonrpc":"2.0","method":"admin_peers","params":[], "id":1}' \
http://127.0.0.1:22000 2>/dev/null | jq
````

This will give a list of enodes belonging to the bootnodes you're connected to.

To see which block you're at , simply issue

````
geth --exec 'eth.blockNumber' attach http://127.0.0.1:22000
````

You might just want to see the number of peers you have (should be all bootnodes as long as they have the last version of the json file containing your enode)

````
curl -X POST -H "Content-Type: application/json"  --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[], "id":1}' \
http://127.0.0.1:22000 2>/dev/null | jq
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "0x4"
}
````


With this call you can see the validators' **etherbases** (also called coinbases) and their mining activity

````
curl -X POST -H "Content-Type: application/json"  --data '{"jsonrpc":"2.0","method":"istanbul_status","params":[], "id":1}' http://127.0.0.1:22000 2>/dev/null | jq
````

You will see something like this:

````
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "sealerActivity": {
      "0x20622fcba34c35a0cb53e91ba37e4f00215dff0b": 8,
      "0x6980a7683a1936197ad7bf6cb0c26f1ff4151905": 8,
      "0x72fdfab893f10fa40d1e843cfc6cb8e0c2c17e10": 8,
      "0x7414c1b34e38087a9c045f46549006e70bb00fc3": 8,
      "0xa9472bd1cad83af9285cbc4cdd5ffac484e886c2": 8,
      "0xb87dc349944cc47474775dde627a8a171fc94532": 8,
      "0xe1f33a9af3abc7ce84f6a73c6ca62181be08378e": 8,
      "0xfad2a6b1bfa8330f1ecbdaa125986942b98d497f": 8
    },
    "numBlocks": 64
  }
}

````

If you want to see your own node's **etherbase**  you can issue 

````
geth --exec 'eth.coinbase' attach http://127.0.0.1:22000
````
or the equivalent

````
curl -X POST -H "Content-Type: application/json"  --data '{"jsonrpc":"2.0","method":"eth_coinbase","params":[], "id":1}' \
http://127.0.0.1:22000 2>/dev/null | jq
````


The result is a hash of your e-node (your node's public key).


