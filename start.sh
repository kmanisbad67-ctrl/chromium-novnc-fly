#!/bin/bash
set -Eeuo pipefail

cleanup() {
  jobs -pr | xargs -r kill 2>/dev/null || true
}
trap cleanup EXIT INT TERM

export DISPLAY="${DISPLAY:-:1}"
SCREEN_WIDTH="${SCREEN_WIDTH:-1280}"
SCREEN_HEIGHT="${SCREEN_HEIGHT:-800}"
SCREEN_DEPTH="${SCREEN_DEPTH:-24}"
VNC_PORT="${VNC_PORT:-5900}"
NOVNC_PORT="${NOVNC_PORT:-8080}"
VNC_PASSWORD_FILE="${VNC_PASSWORD_FILE:-/tmp/vnc-password}"

if [[ -n "${VNC_PASSWORD:-}" ]]; then
  x11vnc -storepasswd "$VNC_PASSWORD" "$VNC_PASSWORD_FILE" >/dev/null
  VNC_AUTH=(-rfbauth "$VNC_PASSWORD_FILE")
else
  # The VNC server is reachable only through the local websockify proxy.
  VNC_AUTH=(-nopw)
fi

Xvfb "$DISPLAY" -screen 0 "${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_DEPTH}" -ac +extension GLX +render -noreset &

until xdpyinfo -display "$DISPLAY" >/dev/null 2>&1; do
  sleep 0.1
done

openbox --display "$DISPLAY" &

chromium \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --no-first-run \
  --no-default-browser-check \
  --start-maximized \
  "${CHROMIUM_URL:-about:blank}" &

x11vnc \
  -display "$DISPLAY" \
  -forever \
  -shared \
  -localhost \
  -rfbport "$VNC_PORT" \
  "${VNC_AUTH[@]}" &

websockify \
  --web=/usr/share/novnc \
  --wrap-mode=ignore \
  "$NOVNC_PORT" \
  "localhost:$VNC_PORT" &

wait -n
