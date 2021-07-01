#!/bin/bash
NAME=openaudible

# Build docker image

# Stop and remove any older instances
docker stop $NAME
docker rm $NAME

# Where your books, web page, and artwork files will be saved
VOLUME /config/OpenAudible
#VOLMAP = "-v /local/openaudible:/config/OpenAudible
set -e

docker build -t $NAME .
echo "Open your browser to http://localhost:3000"
docker run -d -it $VOLMAP -p 3000:3000 --name $NAME $NAME
docker logs -f $NAME

