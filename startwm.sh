#!/bin/bash
/usr/bin/pulseaudio --start

# Start OpenAudible
OpenAudible &
# create desktop shortcut 
mkdir -p /config/Desktop
cp  /usr/local/OpenAudible/OpenAudible.desktop ~/Desktop/OpenAudible.desktop

# This blocks until user closes session

/usr/bin/startxfce4 > /dev/null 2>&1


