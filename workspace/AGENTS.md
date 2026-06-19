# Codex Workspace

This is the shared workspace for server-aware Codex chats on `nixos-pc`.

## First Reads

- For server work, read `/srv/workspace/docs/server.md`.
- For Nix and temporary tooling, read `/srv/workspace/docs/nix.md`.
- For repo layout and workflows, read `/srv/workspace/docs/ops-map.md`.
- For durable infrastructure changes, read `/srv/ops/README.md` and the
  relevant `/srv/ops/runbooks/*.md`.

## Operating Rules

- `/srv/ops` is the source of truth for NixOS, routes, service modules, scripts,
  runbooks, and Codex desired config.
- `/srv/state` is durable runtime state. Inspect it when needed, but do not make
  durable config changes there.
- `/srv/workspace/repos` is for cloned or generated project repositories.
- `/srv/workspace/scratch` is for disposable experiments.
- `/srv/workspace/tmp` is for short-lived files that may be deleted.

## Nix Tooling

- Prefer Nix-provided tools over ad hoc package managers.
- Start the workspace shell with `nix develop /srv/workspace`.
- For one-off tools, use:
  `nix shell --inputs-from /srv/ops nixpkgs#<package> --command <command>`.
- If Nix cache writes fail in a sandbox, set
  `XDG_CACHE_HOME=/tmp/codex-nix-cache`.
- If Nix needs the daemon socket, network, or host-level permissions, ask for a
  scoped approval and explain the exact command.

## Secrets

- Never commit secrets.
- Do not print secret values unless the user explicitly asks and the operation is
  necessary.
- The encrypted local secrets file is
  `/home/rishabh/.config/homelab/secrets.yaml`.
- Use `/srv/ops` scripts for secret workflows:
  `just secrets-edit`, `just secrets-check`, `just cloudflare-store-token`,
  `just tailscale-store-oauth`, `just codex-store-auth`, and
  `just bitwarden-promote`.

## Changes And Verification

- Make durable server changes in `/srv/ops`.
- Run the narrowest relevant checks first, usually `just check`, `just build`,
  `just test`, or `just routes` from `/srv/ops`.
- Use `just switch` only when the user wants to apply a new NixOS generation.
- Use `just workspace-sync` after changing the ops-owned workspace scaffold.

