#!/bin/bash
echo "Starting OpenAudible"

# Check if OpenAudible is already installed
if [ ! -f "/app/OpenAudible/OpenAudible" ]; then
	echo "Running installer..."
	/config/install.sh &
else
    echo "Launching OpenAudible..."
    /app/OpenAudible/OpenAudible &
fi
