#!/usr/bin/env bash
set -Eeuo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"

for command_name in docker curl grep; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$command_name" >&2
    exit 127
  fi
done

if ! docker info >/dev/null 2>&1; then
  printf 'Docker Engine is not reachable.\n' >&2
  exit 1
fi

project_name=${COMPOSE_PROJECT_NAME:-dfl-test-$$}
export COMPOSE_PROJECT_NAME=$project_name
export WEB_PORT=${WEB_PORT:-0}

cleanup() {
  docker compose --profile tools down --volumes --remove-orphans >/dev/null 2>&1 || true
}
trap cleanup EXIT

printf '[1/8] Validate Compose configuration\n'
docker compose --profile tools config --quiet

printf '[2/8] Build the web image\n'
docker compose build --pull web

printf '[3/8] Start the web service and wait for health\n'
docker compose up --detach --wait web

published=$(docker compose port web 8080)
host_port=${published##*:}
base_url="http://127.0.0.1:$host_port"

printf '[4/8] Test HTTP content and health\n'
page=$(curl --fail --silent --show-error --retry 5 --retry-delay 1 "$base_url/")
grep --quiet 'Docker Foundations Lab' <<<"$page"
health=$(curl --fail --silent --show-error "$base_url/health")
[[ $health == 'ok' ]]

printf '[5/8] Test Docker DNS on the application network\n'
probe_result=$(docker compose --profile tools run --rm probe)
[[ $probe_result == 'ok' ]]

printf '[6/8] Verify non-root and read-only runtime settings\n'
runtime_uid=$(docker compose exec -T web id -u)
if [[ $runtime_uid == 0 ]]; then
  printf 'The web service unexpectedly runs as root.\n' >&2
  exit 1
fi

container_id=$(docker compose ps --quiet web)
readonly_root=$(docker inspect --format '{{.HostConfig.ReadonlyRootfs}}' "$container_id")
[[ $readonly_root == true ]]

printf '[7/8] Prove named-volume persistence across helper containers\n'
docker compose --profile tools run --rm evidence-writer >/dev/null
volume_result=$(docker compose --profile tools run --rm evidence-reader)
grep --quiet '^volume persistence verified at ' <<<"$volume_result"

printf '[8/8] Check web logs and final service state\n'
docker compose logs --no-color web | grep --quiet 'GET /'
docker compose ps web

printf '\nAll Docker Foundations Lab checks passed.\n'
