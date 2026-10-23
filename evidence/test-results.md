# Test evidence

Do not paste secrets, full environment dumps, or unrelated host information here.

## Automated test

Run from a clean clone:

```bash
bash scripts/test.sh
```

Record:

```text
Date:
Environment:
Docker Engine:
Docker Compose:
Git commit:
Result:
```

## Required observations

| Check | Expected evidence |
|---|---|
| Compose validation | exit code 0 |
| image build | successful final image |
| web health | service is `healthy` |
| host HTTP | page contains `Docker Foundations Lab` |
| container DNS | probe returns `ok` from `http://web:8080/health` |
| runtime user | UID is not 0 |
| root filesystem | `ReadonlyRootfs` is `true` |
| volume persistence | reader finds timestamp written by a previous container |
| cleanup | test project containers/network/volume are gone |

GitHub Actions provides repeatable evidence for the committed version. Local Debian evidence should be added only after you personally run and understand the test.
