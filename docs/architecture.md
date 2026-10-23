# Architecture

## Components

| Component | Purpose | Exposure |
|---|---|---|
| `web` | Serves the static status page and `/health` | `127.0.0.1:${WEB_PORT}:8080` |
| `probe` | Tests service discovery on the Compose network | no host port; tools profile only |
| `evidence-writer` | Writes a timestamp to the named volume | network disabled; tools profile only |
| `evidence-reader` | Reads the timestamp from a new container | network disabled; volume read-only |
| `app` network | Provides isolated connectivity and Docker DNS | local Docker bridge |
| `evidence` volume | Stores demonstration data independently of containers | managed by Docker |

## Request path

```text
Host request:
curl 127.0.0.1:8080
  -> published host port
  -> web:8080
  -> Nginx
  -> /usr/share/nginx/html/index.html

Container request:
probe
  -> Docker DNS resolves "web"
  -> app network
  -> web:8080/health
```

## Data lifetime

- Files copied by the Dockerfile are part of the image.
- Runtime changes to a normal container writable layer disappear with the container.
- The `evidence` named volume exists separately from helper containers.
- `docker compose down` keeps the volume.
- `docker compose down --volumes` deletes it.

## Buildtime and runtime

At buildtime, Docker reads the Dockerfile, copies the Nginx configuration and site into the image, and records metadata. At runtime, Compose creates a container, network, port mapping, temporary `/tmp`, and healthcheck from that image.
