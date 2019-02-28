#!/bin/bash
docker pull alastria-node
./destroy_docker.sh
./launch_docker.sh