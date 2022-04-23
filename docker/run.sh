#!/bin/bash
set -e
set -u

echo "example usage run.sh device name xserver"
if [ $# -eq 2 ]
then
    echo "running docker without display"
    docker run -it --rm -v ~/.docker_bash_history:/home/intuinno/.bash_history -v /home/intuinno/codegit/:/home/intuinno/codegit:Z -v /home/intuinno/.ssh/:/home/intuinno/.ssh -w /home/intuinno --user "$(id -u):$(id -g)" --ipc=host --network=host --gpus $1   --name=$2 skinner_legged /bin/bash
else
    export DISPLAY=$DISPLAY
	echo "setting display to $DISPLAY"
	xhost +
	docker run -it --rm -v "$HOME/.Xauthority:/home/intuinno/.Xauthority:rw" -v /tmp/.X11-unix:/tmp/.X11-unix -v /home/intuinno/codegit/:/home/intuinno/codegit:Z -v /home/intuinno/.ssh/:/home/intuinno/.ssh -w /home/intuinno/codegit --ipc=host -e DISPLAY=$DISPLAY --user "$(id -u):$(id -g)" --network=host --gpus $1 --name=$2 -v ~/.docker_bash_history:/home/intuinno/.bash_history skinner_legged /bin/bash 
	xhost -
fi
