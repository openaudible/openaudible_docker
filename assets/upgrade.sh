#!/bin/bash
# Upgrade OpenAudible to the latest version. Script for Linux users.
set -x
set -e  # Exit on any error

# Determine architecture and build installer URL
ARCH="$(uname -m)"

if ![ "$ARCH" = "x86_64" ] || ![ "$ARCH" = "aarch64" ]; then
    echo "Error: Unsupported architecture $ARCH" >&2
    exit 1
fi

# Determine version to install
if [ "$OA_VERSION" = "latest" ] || [ "$OA_VERSION" = "" ]; then
    BASE_URL="https://openaudible.org/latest"
    VERSION_NO=""
    BETA_STR=""
elif [ "$OA_VERSION" = "beta" ]; then
    BASE_URL="https://openaudible.org/latest"
    VERSION_NO=""
    BETA_STR="?beta=true"
elif 
    BASE_URL="https://github.com/openaudible/openaudible/releases/download/v${OA_VERSION}"
    VERSION_NO="_${OA_VERSION}"
    BETA_STR=""
fi

INSTALLER_URL="${BASE_URL}/OpenAudible${VERSION_NO}_${ARCH}.sh${BETA_STR}"

FILE=/tmp/openaudible_installer.sh
echo "Welcome to OpenAudible for Docker!"
echo "Downloading OpenAudible for $(uname -m)..."
echo "Version mode: ${VERSION}"
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

