#!/bin/bash
set -e
set -u

if [ $# -eq 2 ]
then
    docker run  --rm -e "ACCEPT_EULA=Y"  -v /home/intuinno/codegit/:/home/intuinno/codegit:Z  --ipc=host --network=host --gpus $1   --name=$2 nvcr.io/nvidia/isaac-sim:2021.2.1
else
    echo "example usage run_isaac_sim.sh device name"
fi
