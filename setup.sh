#!/bin/bash
echo "start install `date` ">>/tmp/oa.txt
    cd /config
    echo "First time setup... Downloading latest OpenAudible...."  
    wget -q https://openaudible.org/latest/OpenAudible_x86_64.sh -O openaudible_installer.sh 
    echo "Running OpenAudible installer"  
    sudo sh ./openaudible_installer.sh -q -overwrite -dir /usr/local/OpenAudible 
    rm openaudible_installer.sh 
    cp -f /usr/local/OpenAudible/OpenAudible.desktop ~/Desktop/OpenAudible.desktop
echo "end install `date` ">>/tmp/oa.txt

echo "Launching OpenAudible!  This terminal will close in 10 seconds..."

nohup OpenAudible >/dev/null 2>&1 &
echo "More information available at https://hub.docker.com/r/openaudible/openaudible and openaudible.org"
sleep 10

exit


