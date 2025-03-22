#!/bin/bash
# Upgrade OpenAudible to the latest version. Script for Linux users.

set -e  # Exit on any error
FILE=/tmp/openaudible_installer.sh
INSTALLER_URL="https://openaudible.org/latest/OpenAudible_x86_64.sh?beta=0"
echo "Welcome to OpenAudible for Docker! Installing OpenAudible"

echo "Downloading latest version..."
if ! wget --show-progress -q "$INSTALLER_URL" -O "$FILE"; then
    echo "Error: Failed to download the installer." >&2
    exit 1
fi

echo "Installing OpenAudible..."
if ! sh "$FILE" -q -overwrite -dir /config/OpenAudible; then
    echo "Error: Installation failed." >&2
    rm -f "$FILE"
    exit 1
fi

rm -f "$FILE"
echo "Upgrade completed successfully."
echo "Starting OpenAudible"

nohup /config/OpenAudible/OpenAudible >/dev/null 2>&1 &

sleep 5

exit 0

