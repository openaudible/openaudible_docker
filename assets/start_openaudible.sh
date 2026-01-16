#!/bin/bash
echo "Starting OpenAudible"

# Check if OpenAudible is already installed
if [ ! -f "/app/OpenAudible/OpenAudible" ]; then
	echo "Running installer..."
	/app/install.sh &
else
    echo "Launching OpenAudible..."
    /app/OpenAudible/OpenAudible &
fi
