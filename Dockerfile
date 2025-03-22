FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm
# Dockerfile to run OpenAudible in a kasmvnc web container using Docker.

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV LANGUAGE=C.UTF-8
# Enable audio by default
ENV KASM_AUDIO_ENABLED=1
# Set KASM audio quality (optional, values: low, medium, high)
ENV KASM_AUDIO_QUALITY=medium
ENV START_PULSEAUDIO=1
ENV OA_PACKAGING=docker
ENV BROWSER=/usr/bin/firefox-esr
ENV XDG_CURRENT_DESKTOP=XFCE


# Install additional packages required for OpenAudible
RUN apt-get update && apt-get install -y \
    libgtk-3-bin \
    ca-certificates \
    wget \
    libwebkit2gtk-4.1-0 \
    vim \
    xdg-utils \
    firefox-esr \
    thunar \
    python3-xdg \
    pulseaudio \
    alsa-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set Firefox as the default browser
RUN update-alternatives --set x-www-browser /usr/bin/firefox-esr && \
    update-alternatives --set gnome-www-browser /usr/bin/firefox-esr

COPY assets/*.sh /config
RUN chmod +x /config/*.sh
COPY assets/index.html /kclient/public/index.html

# Set up to autostart our script instead of OpenAudible directly
RUN echo "/config/start_openaudible.sh" > /defaults/autostart
RUN chown -R abc /config && chgrp -R abc /config

ENTRYPOINT ["/config/entrypoint.sh"]
CMD ["/init"]

# Expose the web interface port
EXPOSE 3000

