# ALASTRIA Red T #
[![Slack Status](https://img.shields.io/badge/slack-join_chat-white.svg?logo=slack&style=social)](https://alastria.slack.com/)

* Visit [What is alastria](https://alastria.io/en/) page to know more about us.

This page contains technical information needed to work in the Alastria ecosystem on the possible different ways.

You'll need at least a host/node to interact with the network, please read the technical requirements for it.

[//]: # ( Para ello, necesitarás como mínimo un nodo para poder intercatuar, ese nodo ha de tener por lo menos las siguientes especificaciones: )

## System requirements

**Operating System**: Ubuntu 16.04 64 bits; Ubuntu 18.04 64 bits

**Hardware**:

| Hardware | minimum | desired |
|:------- |:-------- |:---------|
| **CPU's**: | 2 |  4 |
| **Memory**: | 4 Gb |  8 Gb |
| **Hard Disk**: | 100 Gb |  1000 Gb |


#### TCP/UDP PORTS

You'll need to open the following ports in both ways to deploy a node:

[//]: # (También es necesario habilitar los siguientes puertos de E/S en la maquina en la que vamos a desplegar el nodo:)

| Port | Type | Definition |
|:------:|:-----:|:---------- |
|21000| TCP/UDP | Geth process application port |
|9000| TCP | Constellation port (private transactions)|
|22000| TCP | RPC Port (this can be internal only) |
|80 y 443| TCP | RPC Port if using the automatic installation with Alastria Open Access Component|


## Installation & configuration of

### [Regular node] Quorum node + Constellation + Access point + Monitor

* [(English) Installation Guide](https://medium.com/babel-go2chain/setting-in-motion-a-regular-node-in-the-telsius-network-of-alastria-c2d67b8369c7)
* [(Spanish) Installation Guide](https://medium.com/babel-go2chain/c%C3%B3mo-poner-en-marcha-un-nodo-regular-en-la-red-telsius-de-alastria-876d9dcf7ccb)
* Repository of the access-point that comes installed inside the docker of the regular node [Access-point](https://github.com/alastria/alastria-access-point)

### [Regular node] Quorum node installation using Ansible from host machine

* [(English) Installation Guide](https://github.com/alastria/alastria-node/blob/testnet2/ansible/README.md)

### [Validator node] Quorum node + Access point + Monitor

* [(English) Installation Guide](https://medium.com/babel-go2chain/setting-in-motion-a-validator-node-in-the-telsius-network-of-alastria-906629bc6920)
* [(Spanish) Installation Guide](https://medium.com/babel-go2chain/c%C3%B3mo-poner-en-marcha-un-nodo-validador-en-la-red-telsius-de-alastria-676bdccc253a)

### [Bootnode node] Quorum node

* [(English) Installation Guide](https://medium.com/babel-go2chain/setting-in-motion-a-bootnode-in-the-telsius-network-of-alastria-8e13915cb85d)
* [(Spanish) Installation Guide](https://medium.com/babel-go2chain/c%C3%B3mo-poner-en-marcha-un-bootnode-en-la-red-telsius-de-alastria-18eacb20b224)

## Deployment of Smart Contracts on Alastria Network
To know more about the use of Alastria Network, you can visit the Smart Contract Deployment Guides:
* [Deploying to Alastria's network T (Quorum)](https://github.com/rogargon/copyrightly.io/blob/master/docs/NetworkT.md), created by Roberto Garcia, from Lleida University
* [Deploying to Alastria's Red T using Remix & Metamask](https://medium.com/@jmolino/como-desplegar-un-smart-contract-en-la-red-t-de-alastria-utilizando-remix-y-metamask-782463997a34) created by Jose María del Molino, from AYESA
* [Deploying to Alastria's Red T using Truffle (Quorum)](https://medium.com/babel-go2chain/como-desplegar-un-smart-contract-contra-la-red-t-de-alastria-56939034e884) created by Guillermo Araujo, from Babel

## Connection from External Applications using WebSockets
* [Connecting to an Alastria's Red T node using WebSockets](https://tech.tribalyte.eu/blog-websockets-red-t-alastria) created by Ronny Demera, from Tribalyte

## Alastria network resources

[//]: # ( Aquí encontrarás una lista con enlaces a diferentes servicios de la red alastria, netstats, blockexplorers, etc. )

List of links with resources for the Alastria Network

* **WIKI**
	* [Home](https://github.com/alastria/alastria-node/wiki)
	* [F.A.Q.](https://github.com/alastria/alastria-node/wiki/FAQ_INDEX_EN)

* **Resources**
	* [Network Monitors (ethnetstats)](https://github.com/alastria/alastria-node/wiki/Links)
	* [Blockexplorers](https://github.com/alastria/alastria-node/wiki/Links)
	* [Access-point](https://github.com/alastria/alastria-access-point)

* **¿Need Help?**
	* [Slack](https://github.com/alastria/alastria-node/wiki/HELP)
	* [Github (use & governance)](https://github.com/alastria/alastria-node/wiki/HELP)
