# Controlled failure labs

Create a branch or copy the affected file before each exercise. Restore the original and rerun `bash scripts/test.sh` after every lab.

## 1. Invalid Compose YAML

Change `image:` to `image` in a copied Compose file.

Expected layer: configuration parsing.

Check:

```bash
docker compose -f compose-broken.yaml config
```

Evidence: the first relevant parser error, the corrected line, and a successful `config` run.

## 2. Occupied host port

Start a temporary container on the configured host port, then start this project.

Expected layer: Docker runtime/port allocation.

Evidence: the conflicting listener/container, the error, a different chosen host port, and successful HTTP.

## 3. Missing `COPY` source

Change the Dockerfile to copy a file that does not exist in the build context.

Expected layer: image build.

Evidence: build error, build-context explanation, restored source, and successful rebuild.

## 4. Probe on the wrong network

Temporarily remove the probe from the `app` network or run an unrelated Alpine container without that network.

Expected layer: Docker DNS/network membership.

Evidence: name-resolution error followed by a successful test on the correct network.

## 5. Invalid runtime command

Temporarily override the web service command with a nonexistent executable.

Expected layer: container runtime/process.

Evidence: `docker compose ps --all`, logs/runtime error, restored command, healthy status.

## Report format

For every failure, write:

```text
prediction
command
first relevant error
failing layer
hypothesis
one change
same check repeated
cleanup
```
