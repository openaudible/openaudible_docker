#!/bin/bash
NAME=openaudible

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
docker run -d -it -v $OA_DIR:/config/OpenAudible -p 3000:3000 -e PUID=$PUID -e PGID=$PGID  --name $NAME $NAME


# or run without mapping the volume.... 
# docker run -d -it -p 3000:3000 --name $NAME $NAME

echo "OpenAudible container started... open a web browser to http://localhost:3000 "
echo "Data file will be saved to $OA_DIR once the application has started for the first time"

# If you want, uncomment this to show the logs as things start up.
# You can cancel out (CTRL-C) and the container will continue to run
# docker logs -f $NAME



