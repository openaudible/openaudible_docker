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
ENV oa_internal_browser=true
ENV OA_DOCKER=true

# Install additional packages required for OpenAudible
RUN apt-get update && apt-get install -y \
    libgtk-3-bin \
    ca-certificates \
    wget \
    libwebkit2gtk-4.1-0 \
    vim \
    xdg-utils \
    thunar \
    python3-xdg \
    pulseaudio \
    alsa-utils \
    xterm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


COPY assets/*.sh /config/
RUN chmod +x /config/*.sh
COPY assets/index.html /kclient/public/index.html

# Copy OpenAudible desktop launcher
COPY assets/OpenAudible.desktop /defaults/OpenAudible.desktop
RUN chmod +x /defaults/OpenAudible.desktop

# Copy Openbox window manager configuration for better window sizing
RUN mkdir -p /defaults/.config/openbox
COPY assets/rc.xml /defaults/.config/openbox/rc.xml

# Step 2: Installer will be downloaded at runtime, just prep the data directory
RUN mkdir -p /config/OpenAudible && \
    chown -R abc:abc /config/OpenAudible

# Copy autostart script
COPY assets/autostart /defaults/autostart
RUN chmod +x /defaults/autostart

RUN chown -R abc /config && chgrp -R abc /config

ENTRYPOINT ["/config/entrypoint.sh"]
CMD ["/init"]

# Expose the web interface port
EXPOSE 3000

