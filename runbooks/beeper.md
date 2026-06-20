# Beeper MCP Runbook

Codex reads Beeper through a repo-owned `beeper@homelab-local` plugin. The
plugin wraps Beeper Desktop's local MCP server on the MacBook.

## MacBook

Beeper Desktop must be running with Desktop API/MCP enabled. Keep Beeper's API
local, then publish it only to the tailnet with Tailscale Serve:

```bash
tailscale serve --http=80 localhost:23373
```

The server expects the MacBook tailnet node to be reachable as:

```text
http://macbook/v0/mcp
```

## Server

Codex enables the Beeper plugin in:

```text
/srv/ops/codex/config.toml
```

The plugin source lives at:

```text
/srv/ops/codex/plugins/beeper
```

The Beeper access token is stored in sops as:

```text
codex-beeper.env
```

with this shape:

```text
CODEX_BEEPER_TOKEN=...
```

Nix materializes the secret to `/run/secrets/codex-beeper.env`, and
`codex-remote-control.service` loads it with systemd's `EnvironmentFile`.
