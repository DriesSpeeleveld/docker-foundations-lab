# Troubleshooting

Use the same order every time. Read state before changing it.

## 1. Validate configuration

```bash
docker compose config
```

If this fails, containers have not started. Fix YAML or interpolation first.

## 2. Inspect service state

```bash
docker compose ps --all
```

Look at state, exit code, health, and published ports.

## 3. Read logs

```bash
docker compose logs web
```

Logs describe process and application behaviour. A stopped container is not automatically a network problem.

## 4. Inspect the port mapping

```bash
docker compose port web 8080
curl --fail http://127.0.0.1:8080/health
```

`connection refused` usually means no process accepts the request at that address/port. An HTTP status such as 404 means the request reached Nginx.

## 5. Test inside the Docker network

```bash
docker compose --profile tools run --rm probe
```

If host HTTP works but the probe fails, inspect network membership and the service name.

## 6. Inspect resolved configuration

```bash
docker compose config
docker inspect "$(docker compose ps --quiet web)"
```

Use the resolved output instead of guessing what Compose applied.

## 7. Change one thing and retest

Record the command, relevant error, hypothesis, one change, and result. Do not reinstall Docker to fix an application-level mistake.
