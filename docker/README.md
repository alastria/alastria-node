# alastria-docker


## Launch a regular node
1. Clone this repository with `git clone https://github.com/Councilbox/cbx-alastria-docker`.
2. Create a file called `NODE_NAME` with only the name of your node as content.
3. Create a file called `NODE_TYPE` with the node type `general` or `validator`.
4. Optionally, create a file called `DATA_DIR` with the directory path where the node's data will be stored.

Execute the `launch.sh` script:
```bash
./launch.sh
```

## Backup keys
```bash
./backup.sh
```

## Backup keys and chain data
```bash
./backup.sh all
```
