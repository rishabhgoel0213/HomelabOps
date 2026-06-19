# Codex Runbook

Codex is managed as a first-class homelab service.

```text
/srv/ops/codex      desired Codex config and plugin source
/srv/state/codex    live Codex runtime state
```

The systemd service uses the Nix-provided `codex` package and sets
`CODEX_HOME=/srv/state/codex`.

Codex-owned implementation caches can include paths such as
`/srv/state/codex/.tmp/plugins/.agents`. That is acceptable as runtime state.
The ops repository carries only the local plugin marketplace source at
`/srv/ops/codex/.agents/plugins/marketplace.json`.

Useful commands:

```bash
just codex-store-auth
just codex-migrate-state
just codex-bootstrap
just codex-update
just codex-auto-update
just codex-prune-user-install
```

`codex-store-auth` stores the current Codex `auth.json` and MCP OAuth
credentials into the SOPS keys `codex-auth.json` and
`codex-credentials.json`. Nix materializes those secrets back into
`/srv/state/codex` when the Codex service starts.

`codex-bootstrap` seeds config, restores auth from `/run/secrets`, configures
the Cloudflare MCP server, and installs enabled plugins declared in
`/srv/ops/codex/config.toml`.

`codex-update` updates the repo-owned Codex package override in
`/srv/ops/packages/codex.nix` to the latest stable upstream `rust-v*` tag and
refreshes the fixed-output source and Cargo vendor hashes.

`codex-auto-update` runs the same package update, switches the NixOS generation
only when the package file changes, and restarts `codex-remote-control.service`.
The systemd timer `codex-auto-update.timer` runs it every morning at 04:30.

`codex-prune-user-install` removes the legacy `~/.local/bin/codex` shim when it
points into `~/.codex`. If no running process still has files open in
`~/.codex`, it syncs durable session data into `/srv/state/codex` and deletes
the legacy home.
