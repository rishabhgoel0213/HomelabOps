# Docker Web App Lab

Copy this directory into `/home/rishabh/Projects/<name>`, add your app files, and run:

```bash
docker compose up
```

Expose it privately:

```bash
cd /srv/ops
just route-add <name> internal http://127.0.0.1:3000
just switch
```
