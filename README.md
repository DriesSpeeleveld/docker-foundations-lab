# Docker Foundations Lab

A small Docker project that demonstrates the fundamentals I learned: building an image, running a service with Compose, publishing a port, using container DNS, persisting data in a named volume, checking health, diagnosing failures, and cleaning up safely.

This repository is intentionally small. The goal is to understand every file and command, not to hide the basics behind a framework.

## Architecture

```text
browser ── http://127.0.0.1:8080 ──> web (Nginx, non-root)
                                           │
                                      app network
                                           │
                                    probe container

evidence-writer ──> named volume <── evidence-reader
```

The web container and probe share the `app` network. The probe reaches the site through Docker DNS at `http://web:8080`; it does not use the published host port. The writer and reader demonstrate that a named volume survives container replacement.

More detail: [architecture](docs/architecture.md).

## Requirements

- Linux with Docker Engine and Docker Compose v2
- Git
- `curl`

The intended learning environment is a Debian VM. No router port-forward is required.

## Quick start

```bash
git clone https://github.com/DriesSpeeleveld/docker-foundations-lab.git
cd docker-foundations-lab
cp .env.example .env
docker compose config
docker compose up --build --detach --wait web
curl http://127.0.0.1:8080/health
```

Open <http://127.0.0.1:8080> in the Debian VM, or use `curl` in its terminal.

Inspect the running project:

```bash
docker compose ps
docker compose logs web
docker compose exec web id
docker network ls
docker volume ls
```

## Test the complete lab

The test script uses an isolated Compose project name and a random host port. It validates the configuration, builds the image, waits for health, tests HTTP, checks Docker DNS, verifies non-root/read-only settings, and proves volume persistence.

```bash
bash scripts/test.sh
```

The script removes only its own test containers, network, image references, and volume when it finishes.

## Named-volume demonstration

```bash
docker compose --profile tools run --rm evidence-writer
docker compose --profile tools run --rm evidence-reader
```

Run the writer again to replace the container while keeping the volume. The reader should still find `/evidence/proof.txt`.

## Safe cleanup

Keep the named volume:

```bash
docker compose --profile tools down --remove-orphans
```

Delete the project containers, network, and named volume:

```bash
docker compose --profile tools down --volumes --remove-orphans
```

Do not use a global prune command for this lab.

## Deliberate failure labs

The project includes five controlled troubleshooting exercises:

1. invalid Compose YAML;
2. occupied host port;
3. missing source in `COPY`;
4. probe on the wrong network;
5. invalid runtime command.

Instructions and recovery checks are in [failure labs](docs/failure-labs.md). Work on a branch or make a copy before changing working files.

## Security decisions

- Nginx runs as the existing unprivileged `nginx` user.
- The service listens on port 8080, so it does not need a privileged port.
- The root filesystem is read-only at runtime.
- `/tmp` is a small temporary filesystem.
- All Linux capabilities are dropped.
- `no-new-privileges` is enabled.
- The host port binds only to `127.0.0.1`.
- The helper containers have no published ports.
- The volume helpers have networking disabled.
- No secrets are required or stored in the image.

See [security](docs/security.md) for the limits of these controls.

## Repository layout

```text
.
├── .github/workflows/validate.yml
├── docs/
├── evidence/
├── scripts/test.sh
├── site/
├── .dockerignore
├── .env.example
├── compose.yaml
├── Dockerfile
├── nginx.conf
└── README.md
```

## Evidence and learning

- [Test evidence](evidence/test-results.md)
- [Architecture](docs/architecture.md)
- [Security notes](docs/security.md)
- [Troubleshooting guide](docs/troubleshooting.md)
- [Failure labs](docs/failure-labs.md)
- [Self-check](docs/learning-checklist.md)

## Known limitations

- This is a learning project, not a production hosting platform.
- It serves a static page and has no authentication or user data.
- The named volume stores demonstration data only.
- Image tags can move over time; updates must be tested before merging.
- TLS is outside this repository's current scope.

## License

MIT. See [LICENSE](LICENSE).
