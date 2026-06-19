# Server Context

This file summarizes stable server facts for Codex chats. The source of truth is
still `/srv/ops`.

## Host

- Hostname: `nixos-pc`.
- User: `rishabh`, group `users`.
- System: NixOS `26.05`, `x86_64-linux`.
- Time zone: `America/New_York`.
- Primary ops repo: `/srv/ops`.
- Runtime state root: `/srv/state`.
- Shared Codex workspace: `/srv/workspace`.

## Network

- Public domain: `therealrishabh.com`.
- Internal domain: `internal.therealrishabh.com`.
- Tailscale IPv4: `100.73.159.103`.
- Tailscale IPv6: `fd7a:115c:a1e0::6b32:9f68`.
- SSH is enabled with key auth only.
- Host firewall allows TCP 22 publicly and trusts `tailscale0`.

## Ingress

- Caddy owns HTTP routing.
- Cloudflare Tunnel owns public ingress for `therealrishabh.com` and
  `*.therealrishabh.com`.
- Cloudflare Tunnel sends public traffic to local Caddy on `127.0.0.1:8080`.
- CoreDNS owns wildcard private DNS for `*.internal.therealrishabh.com`.
- Tailscale split DNS should route `internal.therealrishabh.com` to
  `100.73.159.103`.

## Current Services

- Public site route: `home.therealrishabh.com`.
- Apex and `www` redirect to `home.therealrishabh.com`.
- Vaultwarden route: `vault.internal.therealrishabh.com`.
- Backrest route: `backups.internal.therealrishabh.com`.
- Syncthing route: `sync.internal.therealrishabh.com`.
- Samba share: `smb://files.internal.therealrishabh.com/Remote`.

## Storage And User Content

- Editable public site source: `/home/rishabh/Projects/public-site`.
- Deployed public site state: `/srv/state/public-site`.
- Resume PDF source: `/home/rishabh/Documents/resume/Resume.pdf`.
- GitHub profile README source:
  `/home/rishabh/Documents/github-profile/README.md`.
- Syncthing shares `/home/rishabh/Documents`.
- Samba exports `/home/rishabh/Remote`.

## Secrets

- Secrets are intentionally outside Git.
- Encrypted secrets file:
  `/home/rishabh/.config/homelab/secrets.yaml`.
- SOPS recipient is derived from `/etc/ssh/ssh_host_ed25519_key.pub`.
- Human credentials live in Apple Passwords and Vaultwarden.
- Automation-specific secrets may be promoted into SOPS with
  `/srv/ops/scripts/promote-bitwarden-secret`.

## Codex

- Desired Codex config: `/srv/ops/codex/config.toml`.
- Desired global Codex guidance: `/srv/ops/codex/AGENTS.md`.
- Runtime Codex home: `/srv/state/codex`.
- Runtime Codex service: `codex-remote-control.service`.
- Daily Codex package update timer: `codex-auto-update.timer` at 04:30.
- Enabled MCP servers include Cloudflare API and Beeper.
- Enabled curated plugins include Canva, Cloudflare, GitHub, Gmail, Google
  Calendar, and Google Drive.

