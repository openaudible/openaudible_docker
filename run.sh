#!/bin/bash
NAME=openaudible

# Password is optional. Default user is "abc"
PASSWORD=

# Set to true to download beta versions of OpenAudible
# OA_BETA=true

# Configure where your books, web page, and artwork files will be saved
# Default: $HOME/OpenAudibleDocker
# For Synology NAS, you might use: /volume1/docker/openaudible
# For other systems, use any path you prefer: /path/to/your/data
OA_DIR=${OA_DIR:-$HOME/OpenAudibleDocker}


# Build docker image

# Stop and remove any older instances
docker stop $NAME
docker rm $NAME

set -e

# Use the following User IDs and Group IDs for the container
PUID=`id -u`
PGID=`id -g`

echo "Saving book data to $OA_DIR"

# Create the data directory if it doesn't exist and set correct permissions
# This prevents Docker from creating it as root
if [ ! -d "$OA_DIR" ]; then
    echo "Creating data directory: $OA_DIR"
    mkdir -p "$OA_DIR"
    chown $PUID:$PGID "$OA_DIR"
    echo "Set ownership to $PUID:$PGID"
else
    echo "Data directory already exists"
    # Ensure correct ownership even if directory exists
    current_owner=$(stat -c '%u:%g' "$OA_DIR" 2>/dev/null || stat -f '%u:%g' "$OA_DIR" 2>/dev/null)
    if [ "$current_owner" != "$PUID:$PGID" ]; then
        echo "Warning: Directory owner is $current_owner but should be $PUID:$PGID"
        echo "Attempting to fix ownership..."
        chown $PUID:$PGID "$OA_DIR" || echo "Failed to change ownership. You may need to run: sudo chown $PUID:$PGID $OA_DIR"
    fi
fi

docker build -t $NAME .
echo "Starting $NAME docker container"
# The security-opt argument appears required. Without it, we get Openbox Error launching startup command:

# Build docker run command with optional OA_BETA
DOCKER_RUN_CMD="docker run -d -it -v $OA_DIR:/config/OpenAudible -p 3000:3000 -e PUID=$PUID -e PGID=$PGID --security-opt seccomp=unconfined -e PASSWORD=$PASSWORD"

# Add OA_BETA if set
if [ ! -z "$OA_BETA" ]; then
    DOCKER_RUN_CMD="$DOCKER_RUN_CMD -e OA_BETA=$OA_BETA"
fi

DOCKER_RUN_CMD="$DOCKER_RUN_CMD --name $NAME $NAME"

$DOCKER_RUN_CMD

echo "OpenAudible container started... open a web browser to http://localhost:3000 (it may take a minute to start) "
echo "Data file will be saved to $OA_DIR once the application has started for the first time"

# If you want, uncomment this to show the logs as things start up.
# You can cancel out (CTRL-C) and the container will continue to run

echo "Run docker logs -f $NAME to follow the logs"

docker logs -f $NAME

