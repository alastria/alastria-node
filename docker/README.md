# Alastria Node Docker

## Launch a general/regular node
Navigate to *docker/general/*
Run the command:
```
./init.sh
```
Answer all the questions.

When the script has finished it will be necessary to make a Pull Request to the corresponding repository and branch so that the core team can review the information and add it to the permission.

The corresponding repository is [alastria-node](https://github.com/alastria/alastria-node/tree/testnet2) and the branch will be testnet2.

The files to be modified will be:
* DIRECTORY_REGULAR.md
* data/constellation-nodes.json
* data/regular-nodes.json

The information corresponding to our node can be obtained by executing the git diff command inside our node in *~/alastria-node*

![File Changes](../images/diffs_regular.png)

## Launch a validator node
Navigate to *docker/validator/*
Run the command:
```
./init.sh
```
Answer all the questions.

When the script has finished it will be necessary to make a Pull Request to the corresponding repository and branch so that the core team can review the information and add it to the permission.

The corresponding repository is [alastria-node](https://github.com/alastria/alastria-node/tree/testnet2) and the branch will be testnet2.

The files to be modified will be:
* DIRECTORY_VALIDATOR.md
* data/validator-nodes.json

The information corresponding to our node can be obtained by executing the git diff command inside our node in *~/alastria-node*

![File Changes](../images/diffs_regular.png)
## Launch a bootnode node
Navigate to *docker/bootnode/*
Run the command:
```
./init.sh
```
Answer all the questions.

When the script has finished it will be necessary to make a Pull Request to the corresponding repository and branch so that the core team can review the information and add it to the permission.

The corresponding repository is [alastria-node](https://github.com/alastria/alastria-node/tree/testnet2) and the branch will be testnet2.

The files to be modified will be:
* DIRECTORY_BOOTNODES.md
* data/boot-nodes.json

The information corresponding to our node can be obtained by executing the git diff command inside our node in *~/alastria-node*

![File Changes](../images/diffs_regular.png)


## Scripts
In the directory *docker/scripts/* you can find all the pre-fabricated scripts that you can run on your docker container of the node.
### Start docker node
```bash
./start.sh
```
### Stop docker node
```bash
./stop.sh
```
### Update docker node
```bash
./update.sh
```
### Destroy docker container (but persist the volume)
```bash
./destroy_docker.sh
```
### Launch docker container with same volume and Identity
```bash
./launch_docker.sh
```
### Update docker image from docker hub and relaunch the node
```bash
./update_docker.sh
```
### Full backup (keys and chain data)
```bash
./backup.sh all
```
### Backupt Keys only
```bash
./backup.sh keys
```

### Full backup (keys and chain data)
```bash
./backup.sh all
```
