# Testbewijs

Plak hier geen secrets, volledige omgevingsvariabelen of niet-relevante informatie over je computer.

## Geautomatiseerde test

Voer vanuit een schone clone uit:

```bash
bash scripts/test-lab.sh
```

Noteer:

```text
Datum:
Omgeving:
Docker Engine:
Docker Compose:
Git-commit:
Resultaat:
```

## Vereiste waarnemingen

| Controle | Verwacht bewijs |
|---|---|
| Compose-validatie | exitcode 0 |
| imagebuild | geslaagd eindimage |
| healthstatus website | service is `healthy` |
| HTTP vanaf host | pagina bevat `Docker Foundations Lab` |
| Docker DNS | `controle` ontvangt `ok` van `http://website:8080/health` |
| runtimegebruiker | UID is niet 0 |
| rootbestandssysteem | `ReadonlyRootfs` is `true` |
| volumepersistentie | lezer vindt het tijdstip dat een vorige container heeft geschreven |
| opruiming | testcontainers, netwerk en volume zijn verwijderd |

GitHub Actions levert herhaalbaar bewijs voor de gecommitte versie. Voeg lokaal Debian-bewijs pas toe nadat je de test zelf hebt uitgevoerd en kunt uitleggen.
