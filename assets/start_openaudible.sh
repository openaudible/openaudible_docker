#!/bin/bash
echo "Starting OpenAudible: "
ls /config/
# Check if OpenAudible is already installed
if [ ! -f "/config/OpenAudible/OpenAudible" ]; then
	echo "Running installer"
	/config/install.sh &
else
    echo "Running openaudible"
    # If already installed, just start OpenAudible
    /config/OpenAudible/OpenAudible &
fi
