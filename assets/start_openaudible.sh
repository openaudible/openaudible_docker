#!/bin/bash
# Step 2: Download from URL, install to ~/OpenAudibleApp, then launch
LOGFILE=/tmp/openaudible_autostart.log
exec > >(tee -a "$LOGFILE") 2>&1

echo "==========================================="
echo "OpenAudible autostart script STARTED"
echo "Timestamp: $(date)"
echo "User: $(whoami)"
echo "Display: $DISPLAY"
echo "Home: $HOME"
echo "PWD: $PWD"
echo "==========================================="


# Reload Openbox configuration if it exists
if [ -f ~/.config/openbox/rc.xml ]; then
	echo "Reloading Openbox configuration..."
	openbox --reconfigure 2>/dev/null || true
fi

# Create Desktop directory
mkdir -p ~/Desktop

# Check if OpenAudible is already installed
echo "Checking if OpenAudible is installed at ~/OpenAudibleApp/OpenAudible..."
if [ ! -f "$HOME/OpenAudibleApp/OpenAudible" ]; then
	echo "OpenAudible NOT installed yet - will download and install in xterm"

	# Create inline install script for xterm to run
	INSTALL_SCRIPT="/tmp/do_install.sh"
	cat > "$INSTALL_SCRIPT" << 'EOF'
#!/bin/bash
echo "=========================================="
echo "OpenAudible Installer"
echo "=========================================="
echo ""

INSTALLER_URL="https://openaudible.org/beta/OpenAudible_4.6.9.7_beta_aarch64.sh"
INSTALLER_FILE="/tmp/OpenAudible_installer.sh"

echo "Downloading installer from:"
echo "$INSTALLER_URL"
echo ""

wget -O "$INSTALLER_FILE" "$INSTALLER_URL"
DOWNLOAD_EXIT=$?

if [ $DOWNLOAD_EXIT -ne 0 ]; then
	echo ""
	echo "ERROR: Download FAILED with exit code $DOWNLOAD_EXIT"
	echo "Press Enter to close..."
	read
	exit 1
fi

echo ""
echo "Download complete!"
echo "Installing to ~/OpenAudibleApp..."
echo ""

sh "$INSTALLER_FILE" -q -dir ~/OpenAudibleApp
EXIT_CODE=$?

echo ""
if [ $EXIT_CODE -eq 0 ]; then
	echo "SUCCESS: OpenAudible installed successfully!"
	echo "Closing installer window in 3 seconds..."
	sleep 3
	exit 0
else
	echo "ERROR: Installation FAILED with exit code $EXIT_CODE"
	echo "Press Enter to close..."
	read
	exit 1
fi
EOF

	chmod +x "$INSTALL_SCRIPT"

	# Run the install script in xterm and wait for it to complete
	echo "Starting xterm installer window..."
	xterm -title "OpenAudible Installer" -geometry 100x30 -e "$INSTALL_SCRIPT"
	XTERM_EXIT=$?

	echo "Installer xterm closed with exit code: $XTERM_EXIT"

	# Check if installation succeeded
	if [ -f "$HOME/OpenAudibleApp/OpenAudible" ]; then
		echo "Install succeeded, creating desktop icon..."
		# Copy desktop file to Desktop
		cp /defaults/OpenAudible.desktop ~/Desktop/
		chmod +x ~/Desktop/OpenAudible.desktop
		echo "Launching OpenAudible"
		~/OpenAudibleApp/OpenAudible &
		APP_PID=$!
		echo "OpenAudible started with PID: $APP_PID"
	else
		echo "Install FAILED - OpenAudible binary not found"
	fi
else
    echo "OpenAudible already installed"
    # Make sure desktop icon exists
    if [ ! -f ~/Desktop/OpenAudible.desktop ]; then
    	echo "Creating desktop icon..."
    	cp /defaults/OpenAudible.desktop ~/Desktop/
    	chmod +x ~/Desktop/OpenAudible.desktop
    fi
    echo "Starting application"
    ~/OpenAudibleApp/OpenAudible &
    APP_PID=$!
    echo "OpenAudible started with PID: $APP_PID"
fi

echo "Autostart script completed at $(date)"
echo "==========================================="
