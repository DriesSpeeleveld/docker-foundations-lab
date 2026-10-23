# Docker Foundations Lab

Een klein Dockerproject waarmee ik de basisvaardigheden aantoon die ik heb geleerd: een image bouwen, een service met Compose starten, een poort publiceren, Docker DNS gebruiken, gegevens in een benoemd volume bewaren, healthchecks uitvoeren, fouten onderzoeken en veilig opruimen.

Deze repository blijft bewust klein. Het doel is dat ik ieder bestand en ieder commando kan uitleggen, zonder dat een framework de basis verbergt.

## Architectuur

```text
webbrowser ── http://127.0.0.1:8080 ──> website (Nginx, non-root)
                                               │
                                          labnetwerk
                                               │
                                      controlecontainer

bewijs-schrijver ──> benoemd volume <── bewijs-lezer
```

De website en controlecontainer delen het netwerk `labnetwerk`. De controlecontainer bereikt de website via Docker DNS op `http://website:8080`; hij gebruikt dus niet de gepubliceerde hostpoort. De schrijver en lezer tonen aan dat een benoemd volume blijft bestaan wanneer een container wordt vervangen.

Meer uitleg staat in [architectuur](documentatie/architectuur.md).

## Benodigdheden

- Linux met Docker Engine en Docker Compose v2
- Git
- `curl`

De voorziene leeromgeving is een Debian-VM. Portforwarding op je router is niet nodig.

## Snel starten

```bash
git clone https://github.com/DriesSpeeleveld/docker-foundations-lab.git
cd docker-foundations-lab
cp .env.example .env
docker compose config
docker compose up --build --detach --wait website
curl http://127.0.0.1:8080/health
```

Open <http://127.0.0.1:8080> in de Debian-VM, of gebruik `curl` in de terminal.

Onderzoek het draaiende project:

```bash
docker compose ps
docker compose logs website
docker compose exec website id
docker network ls
docker volume ls
```

## Het volledige lab testen

Het testscript gebruikt een aparte Compose-projectnaam en een willekeurige hostpoort. Het controleert de configuratie, bouwt het image, wacht op een gezonde status, test HTTP en Docker DNS, controleert de non-root- en alleen-lezeninstellingen en bewijst volumepersistentie.

```bash
bash scripts/test-lab.sh
```

Na afloop verwijdert het script alleen zijn eigen testcontainers, netwerk, imageverwijzingen en volume.

## Demonstratie van het benoemde volume

```bash
docker compose --profile hulpmiddelen run --rm bewijs-schrijver
docker compose --profile hulpmiddelen run --rm bewijs-lezer
```

Voer de schrijver opnieuw uit. Docker maakt telkens een nieuwe hulpcontainer, terwijl het volume behouden blijft. De lezer moet `/bewijs/bewijs.txt` nog steeds kunnen lezen.

## Veilig opruimen

Behoud het benoemde volume:

```bash
docker compose --profile hulpmiddelen down --remove-orphans
```

Verwijder de projectcontainers, het netwerk en het benoemde volume:

```bash
docker compose --profile hulpmiddelen down --volumes --remove-orphans
```

Gebruik voor dit lab geen algemeen `prune`-commando.

## Gecontroleerde foutlabs

Het project bevat vijf oefeningen waarin je bewust één fout veroorzaakt en daarna onderzoekt:

1. ongeldige Compose-YAML;
2. bezette hostpoort;
3. ontbrekende bron voor `COPY`;
4. controlecontainer op het verkeerde netwerk;
5. ongeldig runtimecommando.

De opdrachten en herstelcontroles staan in [foutlabs](documentatie/foutlabs.md). Werk op een branch of maak eerst een kopie voordat je werkende bestanden verandert.

## Beveiligingskeuzes

- Nginx draait als de bestaande gebruiker `nginx`, niet als root.
- De service luistert intern op poort 8080 en heeft dus geen geprivilegieerde poort nodig.
- Het rootbestandssysteem is tijdens runtime alleen-lezen.
- `/tmp` is een klein tijdelijk bestandssysteem.
- Alle Linux-capabilities worden verwijderd.
- `no-new-privileges` is ingeschakeld.
- De hostpoort luistert alleen op `127.0.0.1`.
- De hulpcontainers publiceren geen poorten.
- De volumehulpen hebben geen netwerktoegang.
- Er zijn geen secrets nodig en er worden geen secrets in het image opgeslagen.

Lees [beveiliging](documentatie/beveiliging.md) voor de grenzen van deze maatregelen.

## Mappenstructuur

```text
.
├── .github/workflows/controleren.yml
├── bewijs/
│   └── testresultaten.md
├── documentatie/
│   ├── architectuur.md
│   ├── beveiliging.md
│   ├── foutlabs.md
│   ├── leerchecklist.md
│   └── probleemoplossing.md
├── scripts/
│   └── test-lab.sh
├── website/
├── .dockerignore
├── .env.example
├── compose.yaml
├── Dockerfile
├── nginx.conf
└── README.md
```

## Bewijs en leercontrole

- [Testbewijs](bewijs/testresultaten.md)
- [Architectuur](documentatie/architectuur.md)
- [Beveiligingsnotities](documentatie/beveiliging.md)
- [Gids voor probleemoplossing](documentatie/probleemoplossing.md)
- [Foutlabs](documentatie/foutlabs.md)
- [Zelfcontrole](documentatie/leerchecklist.md)

## Gekende beperkingen

- Dit is een leerproject, geen productieplatform.
- Het serveert een statische pagina en bevat geen authenticatie of gebruikersgegevens.
- Het benoemde volume bewaart alleen demonstratiegegevens.
- Imagetags kunnen na verloop van tijd veranderen; updates moeten eerst worden getest.
- TLS valt momenteel buiten de scope van deze repository.

## Licentie

MIT. Zie [LICENSE](LICENSE).
