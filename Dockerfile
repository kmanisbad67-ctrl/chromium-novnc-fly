FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    chromium \
    xvfb \
    x11vnc \
    openbox \
    novnc \
    websockify \
    && rm -rf /var/lib/apt/lists/*

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]
