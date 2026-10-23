# Beveiligingsnotities

## Gebruikte maatregelen

| Maatregel | Reden |
|---|---|
| non-root-gebruiker `nginx` | beperkt de gevolgen wanneer het webproces wordt misbruikt |
| poort 8080 in de container | vermijdt dat Nginx een geprivilegieerde poort moet gebruiken |
| alleen-lezen rootbestandssysteem | blokkeert onverwachte schrijfacties naar het imagebestandssysteem |
| kleine `/tmp`-tmpfs | geeft Nginx tijdelijke ruimte zonder de root schrijfbaar te maken |
| alle capabilities verwijderd | verwijdert kernelrechten die de statische webserver niet nodig heeft |
| `no-new-privileges` | voorkomt dat een proces door uitvoering extra rechten krijgt |
| hostkoppeling op `127.0.0.1` | voorkomt dat het lab op iedere netwerkinterface bereikbaar is |
| expliciet labnetwerk | beperkt service discovery tot aangesloten containers |
| hulpprofiel `hulpmiddelen` | houdt testcontainers buiten de normale runtime |
| netwerk uitgeschakeld voor volumehulpen | de schrijver en lezer hebben geen netwerk nodig |
| `.dockerignore` | houdt Git-metadata, documentatie, bewijs en `.env` buiten de buildcontext |

## Secrets

De toepassing heeft geen secrets nodig. `.env` wordt genegeerd door Git en bepaalt alleen een niet-gevoelige hostpoort. Als een latere versie inloggegevens nodig heeft, commit je enkel een voorbeeldbestand met plaatsaanduidingen. De echte waarde geef je buiten Git en buiten het image door.

## Grenzen

Deze instellingen verkleinen risico's, maar maken een container geen perfecte beveiligingsgrens. Het basisimage en Docker Engine moeten nog steeds worden bijgewerkt. Dit lab biedt geen TLS, authenticatie, verzoekslimieten, webapplicatiefirewall, centrale logs of productiemonitoring.

Publiceer dit lab niet via portforwarding op je thuisrouter.
