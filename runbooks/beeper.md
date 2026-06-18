# Beeper MCP Runbook

Codex reads Beeper through Beeper Desktop's local MCP server on the MacBook.

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

Codex declares the MCP server in:

```text
/srv/ops/codex/config.toml
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
