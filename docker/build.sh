#!/bin/bash
set -e
set -u
SCRIPTROOT="$( cd "$(dirname "$0")" ; pwd -P )"
cd "${SCRIPTROOT}/.." 

echo $(pwd)
docker build --network host -t skinner -f docker/Dockerfile --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) .

