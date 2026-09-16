# Chromium in noVNC

This container runs a full Chromium desktop in a virtual X server and exposes it
through [noVNC](https://novnc.com/). It is useful when a browser needs to be
operated from a web page rather than through a local display.

## Run locally

```bash
docker build -t chromium-novnc .
docker run --rm -p 8080:8080 \
  -e VNC_PASSWORD='choose-a-strong-password' \
  chromium-novnc
```

Open `http://localhost:8080/vnc.html?autoconnect=true&resize=remote`, then enter
the value of `VNC_PASSWORD` when noVNC asks for it.

`VNC_PASSWORD` is optional for local, trusted development. When it is omitted,
the VNC session does not require a password; do not use that mode on a public
deployment.

## Configuration

| Environment variable | Default | Description |
| --- | --- | --- |
| `CHROMIUM_URL` | `about:blank` | URL Chromium opens on startup. |
| `SCREEN_WIDTH` | `1280` | Virtual desktop width in pixels. |
| `SCREEN_HEIGHT` | `800` | Virtual desktop height in pixels. |
| `SCREEN_DEPTH` | `24` | Virtual desktop colour depth. |
| `NOVNC_PORT` | `8080` | HTTP port served by noVNC/websockify. |
| `VNC_PORT` | `5900` | Internal VNC port used by websockify. |
| `VNC_PASSWORD` | unset | Password requested by noVNC. |

The raw VNC server listens only on the container loopback interface. Publish
only the noVNC HTTP port (`8080`) and protect it with `VNC_PASSWORD` when the
service is reachable by other users.
