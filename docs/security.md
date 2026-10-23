# Security notes

## Controls used

| Control | Reason |
|---|---|
| non-root `nginx` user | limits the effect of a compromised web process |
| port 8080 inside the container | avoids the need to bind a privileged port |
| read-only root filesystem | blocks unexpected writes to the image filesystem |
| small `/tmp` tmpfs | provides required temporary space without making the root writable |
| all capabilities dropped | removes kernel privileges the static server does not need |
| `no-new-privileges` | prevents gaining extra privileges through execution |
| host bind `127.0.0.1` | avoids exposing the lab on every host interface |
| explicit application network | limits service discovery to attached containers |
| helper profiles | keeps test containers out of the normal runtime path |
| networking disabled for volume helpers | the writer and reader do not need network access |
| `.dockerignore` | keeps repository metadata, docs, evidence, and `.env` out of the build context |

## Secrets

The application needs no secrets. `.env` is ignored and only configures a non-sensitive host port. If a future version needs credentials, commit an example file with placeholders and inject the real value outside Git and the image.

## Limits

These settings reduce risk; they do not make a container a perfect security boundary. The base image and Docker Engine still require updates. This lab does not provide TLS, authentication, rate limiting, a web application firewall, centralized logs, or production monitoring.

Do not publish this lab through a home-router port-forward.
