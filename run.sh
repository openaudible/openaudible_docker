#!/bin/bash
NAME=openaudible

# Password is option. Default user is "abc" 
PASSWORD=


# Build docker image

# Stop and remove any older instances
docker stop $NAME
docker rm $NAME

# Where your books, web page, and artwork files will be saved
# for this sample script, we set OA_DIR to your home directory/OpenAudible ... You can modify this by editing the OA_DIR variable.
set -e

# Use the following User IDs and Group IDs for the container
PUID=`id -u`
PGID=`id -g`


OA_DIR=$HOME/OpenAudibleDocker
echo "Saving book data to $OA_DIR"


docker build -t $NAME .
echo "Starting $NAME docker container"
# The security-opt argument appears required. 
docker run -d -it -v $OA_DIR:/config/OpenAudible -p 3000:3000 -e PUID=$PUID -e PGID=$PGID --security-opt seccomp=unconfined -e PASSWORD=$PASSWORD --name $NAME $NAME


echo "OpenAudible container started... open a web browser to http://localhost:3000 (it may take a minute to start) "
echo "Data file will be saved to $OA_DIR once the application has started for the first time"

# If you want, uncomment this to show the logs as things start up.
# You can cancel out (CTRL-C) and the container will continue to run

echo "Run docker logs -f $NAME to follow the logs"

# docker logs -f $NAME

