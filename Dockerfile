FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm
# Dockerfile to run OpenAudible in a kasmvnc web container using Docker.

# Validate supported architectures (x86_64 or aarch64)
RUN ARCH="$(uname -m)" && \
    ([ "$ARCH" = "x86_64" ] || [ "$ARCH" = "aarch64" ]) || \
    (echo "ERROR: Unsupported architecture $ARCH. OpenAudible requires x86_64 or aarch64" && exit 1)

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
# if OA_BETA is true, loads beta or latest release
ENV OA_BETA=true
ENV XDG_CURRENT_DESKTOP=XFCE
ENV APP_DIR=/app/OpenAudible
# Disable quit menu
ENV OA_KIOSK=true
ENV oa_internal_browser=true

# Install additional packages required for OpenAudible
RUN apt-get update && apt-get install -y \
    libgtk-3-bin \
    ca-certificates \
    ca-certificates-java \
    wget \
    libwebkit2gtk-4.1-0 \
    vim \
    xdg-utils \
    xterm \
    thunar \
    python3-xdg \
    pulseaudio \
    alsa-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Update CA certificates and ensure Java can access them
RUN update-ca-certificates

COPY assets/*.sh /app/
RUN chown abc:abc /app/*.sh && chmod +x /app/*.sh
COPY assets/index.html /kclient/public/index.html

# Configure Openbox to not auto-maximize windows
COPY assets/configure-openbox /etc/cont-init.d/98-configure-openbox
RUN chmod +x /etc/cont-init.d/98-configure-openbox

# Set up to autostart our script instead of OpenAudible directly
RUN echo "/app/start_openaudible.sh" > /defaults/autostart
RUN chown -R abc:abc /config && chmod -R 755 /config
RUN mkdir -p $APP_DIR && chown -R abc:abc $APP_DIR && chmod 755 $APP_DIR

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["/init"]

# Expose the web interface port
EXPOSE 3000

