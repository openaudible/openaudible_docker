#!/bin/bash
NAME=openaudible

# Build docker image

# Stop and remove any older instances
docker stop $NAME
docker rm $NAME

# Where your books, web page, and artwork files will be saved
# /config/OpenAudible is on the docker, the first argument is the full path to a location on your host machine.
# for this sample script, we set OA_DIR to your home directory/OpenAudible ... You can modify this
set -e


OA_DIR=$HOME/OpenAudible
echo "Saving book data to $OA_DIR"
if [ -d $OA_DIR ]   # For file "if [ -f /home/rama/file ]"
 then
     echo "OpenAudible directory will be $OA_DIR"
else
     echo "Attempting to create data directory $OA_DIR" 
     mkdir -p $OA_DIR
fi


docker build -t $NAME .
echo "Starting $NAME docker container"
docker run -d -it -v $OA_DIR:/config/OpenAudible -p 3000:3000 --name $NAME $NAME

echo "OpenAudible container started... open a web browser to http://localhost:3000 "


# If you want, uncomment this to show the logs as things start up.
# You can cancel out (CTRL-C) and the container will continue to run
# docker logs -f $NAME



