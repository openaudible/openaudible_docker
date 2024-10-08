FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV LANGUAGE=C.UTF-8

# Install additional packages required for OpenAudible
RUN apt-get update && apt-get install -y \
    libgtk-3-bin \
    ca-certificates \
    wget \
    libswt-gtk-4-jni \
    vim \
    xdg-utils \
    firefox-esr \
    thunar \
    python3-xdg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set Firefox as the default browser
RUN update-alternatives --set x-www-browser /usr/bin/firefox-esr && \
    update-alternatives --set gnome-www-browser /usr/bin/firefox-esr

# Download and install OpenAudible
RUN wget -q https://openaudible.org/latest/OpenAudible_x86_64.sh?beta=false -O openaudible_installer.sh && \
    sh ./openaudible_installer.sh -q -overwrite -dir /usr/local/OpenAudible && \
    rm openaudible_installer.sh

# Set up autostart for OpenAudible
RUN echo "OpenAudible" > /defaults/autostart

# Ensure correct permissions
RUN chown abc:abc -R /config /usr/local/OpenAudible

# Create a script to set up the environment
RUN echo '#!/bin/bash\n\
export BROWSER=/usr/bin/firefox-esr\n\
export XDG_CURRENT_DESKTOP=XFCE\n\
exec "$@"' > /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

# Use the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/init"]

# Expose the web interface port
EXPOSE 3000

