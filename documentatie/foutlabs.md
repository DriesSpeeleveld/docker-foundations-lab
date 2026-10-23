# Gecontroleerde foutlabs

Maak vóór iedere oefening een branch of een kopie van het betrokken bestand. Herstel daarna het origineel en voer `bash scripts/test-lab.sh` opnieuw uit.

## 1. Ongeldige Compose-YAML

Maak een kopie van `compose.yaml` als `compose-fout.yaml`. Verander daarin één sleutel `image:` in `image`.

Verwachte laag: inlezen van de configuratie.

Controle:

```bash
docker compose -f compose-fout.yaml config
```

Bewijs: de eerste relevante parserfout, de herstelde regel en een geslaagde `config`-uitvoering.

## 2. Bezette hostpoort

Start tijdelijk een andere container op de ingestelde hostpoort en probeer daarna dit project te starten.

Verwachte laag: Docker-runtime en poorttoewijzing.

Bewijs: de conflicterende container, de foutmelding, een andere gekozen hostpoort en een geslaagde HTTP-test.

## 3. Ontbrekende bron voor `COPY`

Laat het Dockerfile tijdelijk een bestand kopiëren dat niet in de buildcontext bestaat.

Verwachte laag: bouwen van het image.

Bewijs: de buildfout, uitleg over de buildcontext, de herstelde bron en een geslaagde nieuwe build.

## 4. Controlecontainer op het verkeerde netwerk

Verwijder `controle` tijdelijk uit `labnetwerk`, of start een losse Alpine-container zonder dat netwerk.

Verwachte laag: Docker DNS en netwerklidmaatschap.

Bewijs: de fout bij naamomzetting, gevolgd door een geslaagde test op het juiste netwerk.

## 5. Ongeldig runtimecommando

Overschrijf tijdelijk het commando van `website` met een uitvoerbaar bestand dat niet bestaat.

Verwachte laag: container-runtime en processtart.

Bewijs: `docker compose ps --all`, de relevante runtimefout, het herstelde commando en de status `healthy`.

## Verslagformaat

Schrijf voor iedere fout:

```text
voorspelling
commando
eerste relevante fout
falende laag
hypothese
één wijziging
dezelfde controle opnieuw
opruiming
```
