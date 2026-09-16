#!/bin/bash

Xvfb :1 -screen 0 1280x800x24 &
export DISPLAY=:1

openbox &

chromium \
  --no-sandbox \
  --disable-dev-shm-usage \
  --start-maximized \
  about:blank &

x11vnc \
  -display :1 \
  -forever \
  -shared \
  -rfbport 5900 \
  -passwd "$VNC_PASSWORD" &

websockify \
  --web=/usr/share/novnc \
  8080 \
  localhost:5900
