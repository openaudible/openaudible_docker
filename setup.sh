#!/bin/bash

echo "start install `date` ">>/tmp/oa.txt

cd /config
echo "Hello. Thanks for trying OpenAudible for Docker!" 
echo "First time setup... Downloading latest OpenAudible...."  
wget -q --show-progress https://openaudible.org/latest/OpenAudible_x86_64.sh -O openaudible_installer.sh 

echo "Running OpenAudible installer"  
sh ./openaudible_installer.sh -q -overwrite -dir /usr/local/OpenAudible 


err=$?
echo "Install result $err"

if [ $err -eq 0 ] 
then 
  echo "Successfully installed!" 
  rm openaudible_installer.sh
  cp -f /usr/local/OpenAudible/OpenAudible.desktop ~/Desktop/OpenAudible.desktop
  echo "end install `date` ">>/tmp/oa.txt

  echo "Launching OpenAudible.  This terminal will close automatically..."

  nohup OpenAudible >/dev/null 2>&1 &
  echo "More information available at https://hub.docker.com/r/openaudible/openaudible and openaudible.org"
  sleep 20

exit

else 
  echo "Error installing..." >&2 
  sleep 99999
fi




