#!/bin/bash
/usr/bin/pulseaudio --start


# Need to have a UTF-8 friendly LANG set.

export LANG=en_US.UTF-8

FILE=/usr/local/bin/OpenAudible
if [ -f "$FILE" ]; then
    echo "$FILE exists."
    OpenAudible &
else 
    echo "$FILE does not exist. Installing latest version."
    mkdir -p /config/Desktop
    xfce4-terminal --command /config/setup.sh &
fi


# create desktop shortcut 
mkdir -p /config/Desktop

# This blocks until user closes session
/usr/bin/startxfce4 > /dev/null 2>&1

