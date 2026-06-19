# Server Codex Guidance

This Codex home is managed by `/srv/ops`. The source for this file is
`/srv/ops/codex/AGENTS.md`; the runtime copy lives at
`/srv/state/codex/AGENTS.md`.

## Server Context

- Use `/srv/workspace` as the default working area for ad hoc Codex chats.
- Read `/srv/workspace/AGENTS.md` before server, NixOS, Cloudflare, Tailscale,
  Codex, backup, route, or service work.
- Treat `/srv/ops` as the source of truth for durable server configuration.
- Treat `/srv/state` as runtime state. Do not edit service state directly unless
  a runbook calls for it or the user explicitly asks.

## Codex Configuration

- The desired Codex config is `/srv/ops/codex/config.toml`.
- The managed runtime Codex home is `/srv/state/codex`.
- Do not make durable config changes only in `/srv/state/codex`; update
  `/srv/ops/codex` and run the appropriate ops command instead.

## Secrets

- Runtime secrets are outside Git in
  `/home/rishabh/.config/homelab/secrets.yaml`, encrypted with SOPS.
- Prefer the existing scripts such as `just secrets-edit`,
  `just cloudflare-store-token`, `just tailscale-store-oauth`, and
  `just codex-store-auth`.
- Never print, commit, or copy secret values into workspace docs.

