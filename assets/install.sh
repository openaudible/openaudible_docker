#!/bin/bash
set -e
set -x

echo "Starting OpenAudible installation..."

xterm -title "Installing OpenAudible..." -geometry 100x30 -e "bash /config/upgrade.sh && exit || (echo ''; echo 'ERROR: Installation failed! Press Enter to close this window...'; read)" &

