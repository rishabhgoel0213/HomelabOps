# Cloudflare Control Plane

This directory is reserved for declarative Cloudflare resources managed with OpenTofu.

Use `cfctl` for ad hoc commands:

```bash
cfctl verify
cfctl zones
cfctl dns
cfctl api GET /accounts
cfctl wrangler whoami
cfctl tofu init
cfctl tofu plan
```

The command reads credentials from `/run/secrets/cloudflare-admin.env`.

Do not commit `.tfstate`, `.terraform`, or secret values.
