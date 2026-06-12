# Server Ops

This repo is the source of truth for the `nixos-pc` NixOS server.
It is intended to live in a private GitHub repository because it contains
infrastructure topology. Runtime secrets are intentionally kept out of GitHub.

The intended operating model is:

- NixOS flakes own durable host configuration.
- Caddy owns HTTP routing.
- Cloudflare Tunnel owns public ingress for `therealrishabh.com` and `*.therealrishabh.com`.
- `cfctl`, `wrangler`, and OpenTofu own Cloudflare command-line control.
- Tailscale plus CoreDNS own private ingress for `*.internal.therealrishabh.com`.
- Docker owns lab and CUDA workloads.
- sops-nix owns runtime secrets from the local-only `/srv/ops/secrets/homelab.yaml`.
- Apple Passwords and Vaultwarden own human credentials.

Common commands:

```bash
just build
just switch
just routes
just route-add demo public http://127.0.0.1:3000
just route-add vault internal http://127.0.0.1:8222
just rollback
```

Secret-dependent services are disabled by default. Bootstrap them in this order:

1. Install this repo at `/srv/ops`.
2. Configure sops recipients and create the local-only `secrets/homelab.yaml`.
3. Enable `homelab.secrets`.
4. Enable ACME, Cloudflare Tunnel, private DNS, Vaultwarden, backups, and Backrest as credentials become available.

See `runbooks/bootstrap.md` for the detailed first setup.
See `runbooks/cloudflare.md` for Cloudflare admin CLI setup.

The migrated public profile/site source documents from
`github.com/rishabhgoel0213/rishabhgoel0213` are mirrored under
`docs/public-site/`. The served static assets live under `assets/public-site/`.
