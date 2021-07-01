FROM ghcr.io/linuxserver/webtop:ubuntu-xfce

EXPOSE 3000
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libgtk-3-bin ca-certificates wget libswt-webkit-gtk-4-jni vim xdg-utils
RUN apt remove -y xfce4-panel firefox

# Download latest installer for linux
RUN wget https://openaudible.org/latest/OpenAudible_x86_64.sh -O OpenAudible.sh

# Install without prompts
RUN sh OpenAudible.sh -q -overwrite  && rm OpenAudible.sh


# copy slightly modified startvm.sh to defaults to start OpenAudible
COPY startwm.sh /defaults/startwm.sh

# RUN ln -s /usr/local/OpenAudible/OpenAudible.desktop /defaults/Desktop/OpenAudible.desktop



