#!/bin/bash
set -e
set -x

echo "Starting OpenAudible installation..."

xterm -title "Installing OpenAudible..." -geometry 100x30 -e "bash /app/upgrade.sh && exit || (echo ''; echo 'ERROR: Installation failed! Press Enter to close this window...'; read)" &

