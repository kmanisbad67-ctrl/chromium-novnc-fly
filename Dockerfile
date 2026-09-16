FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:1 \
    SCREEN_WIDTH=1280 \
    SCREEN_HEIGHT=800 \
    SCREEN_DEPTH=24 \
    VNC_PORT=5900 \
    NOVNC_PORT=8080

RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    xvfb \
    x11vnc \
    openbox \
    novnc \
    websockify \
    x11-utils \
    ca-certificates \
    fonts-liberation \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --shell /bin/bash chromium

COPY start.sh /start.sh
RUN chmod +x /start.sh

USER chromium

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD websockify --help >/dev/null 2>&1 && test -e /tmp/.X11-unix/X1 || exit 1

CMD ["/start.sh"]
