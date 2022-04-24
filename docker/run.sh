#!/bin/bash
set -e
set -u

echo "example usage run.sh device name xserver"
if [ $# -eq 2 ]
then
    echo "running docker without display"
    docker run -it --rm \
	-v /home/intuinno/codegit/:/home/intuinno/codegit \
	-v /home/intuinno/.ssh/:/home/intuinno/.ssh \
        -v /home/intuinno/.oh-my-zsh/:/home/intuinno/.oh-my-zsh \
	-v $HOME/.docker_zsh_history:/home/intuinno/.zsh_history \
        -v "$HOME/.zshrc:/home/intuinno/.zshrc:ro" \
        -e DOCKER_MACHINE_NAME=$2 \
       --user "$(id -u):$(id -g)" \
       --ipc=host --network=host --gpus $1 --name=$2 \
       skinner_legged /bin/zsh
else
    export DISPLAY=$DISPLAY
	echo "setting display to $DISPLAY"
	xhost +
	docker run -it --rm \
	    -v "$HOME/.Xauthority:/home/intuinno/.Xauthority:rw" \
	    -v /tmp/.X11-unix:/tmp/.X11-unix \
	    -v /home/intuinno/codegit/:/home/intuinno/codegit \
	    -v /home/intuinno/.ssh/:/home/intuinno/.ssh \
	    -v /home/intuinno/.oh-my-zsh/:/home/intuinno/.oh-my-zsh \
	    -v "$HOME/.docker_zsh_history:/home/intuinno/.zsh_history:rw" \
            -v "$HOME/.zshrc:/home/intuinno/.zshrc:ro" \
            -e DOCKER_MACHINE_NAME=$2 \
	    --ipc=host -e DISPLAY=$DISPLAY \
	    --user "$(id -u):$(id -g)" --network=host --gpus $1 --name=$2 \
	    skinner_legged /bin/zsh 
	xhost -
fi
