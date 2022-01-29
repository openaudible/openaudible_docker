#!/bin/bash
/usr/bin/pulseaudio --start


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
# cp  /usr/local/OpenAudible/OpenAudible.desktop ~/Desktop/OpenAudible.desktop

# This blocks until user closes session

/usr/bin/startxfce4 > /dev/null 2>&1


