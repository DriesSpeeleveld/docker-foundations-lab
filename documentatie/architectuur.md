# Architectuur

## Onderdelen

| Onderdeel | Doel | Bereikbaarheid |
|---|---|---|
| `website` | Serveert de statische statuspagina en `/health` | `127.0.0.1:${WEBPOORT}:8080` |
| `controle` | Test service discovery op het Compose-netwerk | geen hostpoort; alleen profiel `hulpmiddelen` |
| `bewijs-schrijver` | Schrijft een tijdstip naar het benoemde volume | netwerk uitgeschakeld; alleen profiel `hulpmiddelen` |
| `bewijs-lezer` | Leest het tijdstip vanuit een nieuwe container | netwerk uitgeschakeld; volume alleen-lezen |
| netwerk `labnetwerk` | Levert afgeschermde communicatie en Docker DNS | lokale Docker-bridge |
| volume `bewijs` | Bewaart demonstratiegegevens los van containers | beheerd door Docker |

## Pad van een aanvraag

```text
Aanvraag vanaf de host:
curl 127.0.0.1:8080
  -> gepubliceerde hostpoort
  -> website:8080
  -> Nginx
  -> /usr/share/nginx/html/index.html

Aanvraag vanuit een container:
controle
  -> Docker DNS vertaalt "website" naar een IP-adres
  -> labnetwerk
  -> website:8080/health
```

## Levensduur van gegevens

- Bestanden die het Dockerfile kopieert, worden onderdeel van het image.
- Wijzigingen in de normale schrijfbare containerlaag verdwijnen met de container.
- Het benoemde volume `bewijs` bestaat los van de hulpcontainers.
- `docker compose down` behoudt het volume.
- `docker compose down --volumes` verwijdert het volume.

## Buildtime en runtime

Tijdens buildtime leest Docker het Dockerfile, kopieert het de Nginx-configuratie en website naar het image en slaat het metadata op. Tijdens runtime maakt Compose op basis van dat image een container, netwerk, poortkoppeling, tijdelijke `/tmp` en healthcheck.
