#!/bin/bash
# This script is used by openaudible to push the latest release to dockerhub

set -e
docker build --pull --no-cache -t openaudible .

# Publish changes to dockerhub
DOCKER_ID_USER="openaudible" 

docker login -u openaudible
docker tag openaudible openaudible/openaudible:latest
docker push openaudible/openaudible:latest


