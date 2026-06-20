# Ops Map

`/srv/ops` is the server's source of truth.

## Main Files

- `flake.nix` pins NixOS and exposes `nixosConfigurations.nixos-pc`.
- `hosts/nixos-pc/default.nix` imports modules and enables current services.
- `Justfile` exposes common operational commands.
- `.sops.yaml` defines the SOPS recipient for the local encrypted secrets file.
- `routes/apps.json` stores user-managed route additions.

## Module Layout

- `modules/core/base.nix` handles boot, networking, SSH, users, Nix settings, and
  base packages.
- `modules/core/filesystem.nix` writes `/etc/homelab/paths.env` and creates
  persistent directories.
- `modules/core/codex.nix` manages Codex package, runtime home, service, and
  auto-update timer.
- `modules/core/cloudflare.nix` provides `cfctl` and Cloudflare Tunnel.
- `modules/core/computer-use.nix` provides temporary VNC/noVNC desktops and the
  internal takeover hub for Codex Computer Use.
- `modules/core/dns.nix` provides CoreDNS for internal wildcard DNS.
- `modules/core/tailscale-api.nix` provides `tsctl`.
- `modules/core/secrets.nix` maps SOPS keys to `/run/secrets`.
- `modules/core/containers.nix` enables Docker.
- `modules/core/gpu.nix` enables NVIDIA and container toolkit.
- `modules/homelab/options.nix` defines shared homelab options and paths.
- `modules/homelab/ingress.nix` converts routes into Caddy virtual hosts.
- `modules/services/*.nix` defines Backrest, Vaultwarden, Syncthing, Samba, and
  the public site.

## Common Workflows

Add an internal route:

```bash
cd /srv/ops
just route-add myapp internal http://127.0.0.1:3000
just routes
just switch
```

Add a public route:

```bash
cd /srv/ops
just route-add demo public http://127.0.0.1:3000
just routes
just switch
```

Deploy the public site:

```bash
cd /srv/ops
just public-site-deploy
```

Sync the GitHub profile README:

```bash
cd /srv/ops
just github-profile-sync
```

Inspect service status:

```bash
cd /srv/ops
just status
just logs caddy.service
```

## Runbooks

- `runbooks/bootstrap.md` - first setup.
- `runbooks/cloudflare.md` - Cloudflare token, tunnel, DNS.
- `runbooks/tailscale.md` - Tailscale OAuth and split DNS.
- `runbooks/backups.md` - Backrest and Restic plans.
- `runbooks/restore.md` - restore discipline.
- `runbooks/codex.md` - managed Codex service.
- `runbooks/computer-use.md` - temporary Codex-controlled desktops.
- `runbooks/beeper.md` - Beeper Desktop MCP over the tailnet.
- `runbooks/syncthing.md` - private file sync.
- `runbooks/smb.md` - Finder SMB share.
- `runbooks/bitwarden-sops.md` - promote selected vault fields into SOPS.
- `runbooks/add-service.md` - route-based service exposure.
- `runbooks/workspace.md` - shared Codex workspace.
