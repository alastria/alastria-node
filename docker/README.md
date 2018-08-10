# alastria-docker

## Build the image
### Node without monitor
```
docker build \
--build-arg DOCKER_VERSION=latest \
-t alastria/alastria-node:latest .
```
### Node with monitor
```
docker build \
--build-arg DOCKER_VERSION=latest \
--build-arg MONITOR_ENABLED=1 \
-t alastria/alastria-node:latest-monitor .
```

## Launch a node manually
Note that `NODE_TYPE` and `NODE_NAME` environment variables have to be specified.
```
docker run -tid \
-v "$(pwd)"/alastria:/root/alastria \
-p 21000:21000 \
-p 21000:21000/udp \
-p 22000:22000 \
-p 9000:9000 \
-p 8443:8443 \
-e NODE_TYPE=<node_type> \
-e NODE_NAME=<node_name> \
--restart unless-stopped \
--name alastria-node \
alastria/alastria-node
```

## Launch a node with `launch.sh`
1. Clone this repository with `git clone https://github.com/alastria/alastria-node`.
2. Change directory to `alastria-node/docker`
2. Create a file called `NODE_NAME` with only the name of your node as content.
3. Create a file called `NODE_TYPE` with the node type `general` or `validator`.
4. Optionally, create a file called `DATA_DIR` with the directory path where the node's data will be stored.

Execute the `launch.sh` script:
```bash
./launch.sh
```

Note: custom `docker run` options can be added as arguments to the script.

## Backup
### Keys only
```bash
./backup.sh
```

### Full backup (keys and chain data)
```bash
./backup.sh all
```
