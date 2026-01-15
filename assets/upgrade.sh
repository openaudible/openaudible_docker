#!/bin/bash
# Upgrade OpenAudible to the latest version. Script for Linux users.
set -x
set -e  # Exit on any error

# Determine architecture and build installer URL
ARCH="$(uname -m)"
BASE_URL="https://openaudible.org/latest"

if [ "$ARCH" = "x86_64" ]; then
    INSTALLER_URL="${BASE_URL}/OpenAudible_x86_64.sh"
elif [ "$ARCH" = "aarch64" ]; then
    INSTALLER_URL="${BASE_URL}/OpenAudible_aarch64.sh"
else
    echo "Error: Unsupported architecture $ARCH" >&2
    exit 1
fi

# Append beta parameter based on OA_BETA environment variable
if [ "$OA_BETA" = "true" ]; then
    INSTALLER_URL="${INSTALLER_URL}?beta=true"
    echo "Beta mode enabled - downloading latest beta version"
else
    INSTALLER_URL="${INSTALLER_URL}?beta=false"
fi

FILE=/tmp/openaudible_installer.sh
echo "Welcome to OpenAudible for Docker!"
echo "Downloading OpenAudible for $(uname -m)..."
echo "Beta mode: ${OA_BETA:-false}"
echo "URL: $INSTALLER_URL"

if ! wget --show-progress -q "$INSTALLER_URL" -O "$FILE"; then
    echo "Error: Failed to download the installer." >&2
    exit 1
fi

echo "Preparing installation directory..."
rm -rf /app/OpenAudible
mkdir -p /app/OpenAudible

echo "Installing OpenAudible..."
chmod +x "$FILE"

if ! sh "$FILE" -q -overwrite -dir /app/OpenAudible; then
    echo "Error: Installation failed." >&2
    rm -f "$FILE"
    exit 1
fi

rm -f "$FILE"
echo "Upgrade completed successfully."
echo "Starting OpenAudible"

nohup /app/OpenAudible/OpenAudible >/dev/null 2>&1 &

sleep 5

exit 0

