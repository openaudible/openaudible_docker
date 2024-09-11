#!/usr/bin/with-contenv bash

# install OpenAudible on firstrun
[[ ! -f /usr/local/OpenAudible/OpenAudible ]] && \
    echo "Downloading OpenAudible installer.." && \
    wget -q https://openaudible.org/latest/OpenAudible_x86_64.sh -O openaudible_installer.sh  && \
    sh ./openaudible_installer.sh -q -overwrite -dir /usr/local/OpenAudible && \
    rm openaudible_installer.sh


