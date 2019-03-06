# Alastria Node Docker

## Launch a general/regular node
Navigate to *docker/general/*
Run the command:
```
./init.sh
```
Answer all the questions
## Launch a validator node
Navigate to *docker/validator/*
Run the command:
```
./init.sh
```
Answer all the questions
## Launch a bootnode node
Navigate to *docker/bootnode/*
Run the command:
```
./init.sh
```
Answer all the questions


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