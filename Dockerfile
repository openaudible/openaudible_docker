FROM ghcr.io/linuxserver/baseimage-rdesktop-web:bionic
COPY init_d_install.sh /etc/cont-init.d/init_d_install.sh

ENV TITLE=OpenAudible
RUN echo "Installing dependencies" && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libgtk-3-bin ca-certificates wget libswt-webkit-gtk-4-jni xdg-utils libnss3-dev && \
    echo "OpenAudible" > /defaults/autostart && \
    echo "Cleaning up" && \
    apt remove -y xfce4-panel firefox && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 3000
#VOLUME /config/OpenAudible - skipping this as baseimage already got VOLUME /config


