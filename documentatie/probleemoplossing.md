# Problemen oplossen

Werk telkens in dezelfde volgorde. Bekijk eerst de huidige toestand voordat je iets wijzigt.

## 1. Controleer de configuratie

```bash
docker compose config
```

Als dit mislukt, zijn er nog geen containers gestart. Herstel eerst de YAML of variabelevervanging.

## 2. Bekijk de servicestatus

```bash
docker compose ps --all
```

Let op toestand, exitcode, healthstatus en gepubliceerde poorten.

## 3. Lees de logs

```bash
docker compose logs website
```

Logs beschrijven het gedrag van het proces en de toepassing. Een gestopte container wijst niet automatisch op een netwerkprobleem.

## 4. Onderzoek de poortkoppeling

```bash
docker compose port website 8080
curl --fail http://127.0.0.1:8080/health
```

`connection refused` betekent meestal dat geen proces op dat adres en die poort luistert. Een HTTP-status zoals 404 betekent dat het request Nginx wel heeft bereikt.

## 5. Test binnen het Docker-netwerk

```bash
docker compose --profile hulpmiddelen run --rm controle
```

Als HTTP vanaf de host werkt maar de controlecontainer faalt, onderzoek je het netwerklidmaatschap en de servicenaam.

## 6. Bekijk de opgeloste configuratie

```bash
docker compose config
docker inspect "$(docker compose ps --quiet website)"
```

Gebruik de opgeloste uitvoer om te zien wat Compose werkelijk heeft toegepast.

## 7. Verander één ding en test opnieuw

Noteer het commando, de eerste relevante fout, je hypothese, één wijziging en het resultaat. Installeer Docker niet opnieuw om een fout op toepassingsniveau op te lossen.
