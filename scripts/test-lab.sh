#!/usr/bin/env bash
set -Eeuo pipefail

projectmap=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$projectmap"

for commando in docker curl grep; do
  if ! command -v "$commando" >/dev/null 2>&1; then
    printf 'Vereist commando ontbreekt: %s\n' "$commando" >&2
    exit 127
  fi
done

if ! docker info >/dev/null 2>&1; then
  printf 'Docker Engine is niet bereikbaar.\n' >&2
  exit 1
fi

projectnaam=${COMPOSE_PROJECT_NAME:-dfl-test-$$}
export COMPOSE_PROJECT_NAME=$projectnaam
export WEBPOORT=${WEBPOORT:-0}

opruimen() {
  docker compose --profile hulpmiddelen down --volumes --remove-orphans >/dev/null 2>&1 || true
}
trap opruimen EXIT

printf '[1/8] Compose-configuratie controleren\n'
docker compose --profile hulpmiddelen config --quiet

printf '[2/8] Website-image bouwen\n'
docker compose build --pull website

printf '[3/8] Website starten en op gezonde status wachten\n'
docker compose up --detach --wait website

gepubliceerd=$(docker compose port website 8080)
hostpoort=${gepubliceerd##*:}
basis_url="http://127.0.0.1:$hostpoort"

printf '[4/8] HTTP-inhoud en health-endpoint testen\n'
pagina=$(curl --fail --silent --show-error --retry 5 --retry-delay 1 "$basis_url/")
grep --quiet 'Docker Foundations Lab' <<<"$pagina"
gezondheid=$(curl --fail --silent --show-error "$basis_url/health")
[[ $gezondheid == 'ok' ]]

printf '[5/8] Docker DNS op het labnetwerk testen\n'
controleresultaat=$(docker compose --profile hulpmiddelen run --rm controle)
[[ $controleresultaat == 'ok' ]]

printf '[6/8] Non-root- en alleen-lezeninstellingen controleren\n'
runtime_uid=$(docker compose exec -T website id -u)
if [[ $runtime_uid == 0 ]]; then
  printf 'De website draait onverwacht als root.\n' >&2
  exit 1
fi

container_id=$(docker compose ps --quiet website)
alleen_lezen_root=$(docker inspect --format '{{.HostConfig.ReadonlyRootfs}}' "$container_id")
[[ $alleen_lezen_root == true ]]

printf '[7/8] Persistentie van het benoemde volume bewijzen\n'
docker compose --profile hulpmiddelen run --rm bewijs-schrijver >/dev/null
volumeresultaat=$(docker compose --profile hulpmiddelen run --rm bewijs-lezer)
grep --quiet '^volumepersistentie gecontroleerd op ' <<<"$volumeresultaat"

printf '[8/8] Weblogs en uiteindelijke servicestatus controleren\n'
docker compose logs --no-color website | grep --quiet 'GET /'
docker compose ps website

printf '\nAlle controles van het Docker Foundations Lab zijn geslaagd.\n'
