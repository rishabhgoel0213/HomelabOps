# Codex Computer Use

This server integrates
[`iFurySt/open-codex-computer-use`](https://github.com/iFurySt/open-codex-computer-use)
as a Nix-managed Computer Use runtime for temporary Linux desktops.

The durable source lives in `/srv/ops`; runtime desktops and logs live under:

```text
/srv/state/codex/computer-use
```

## Architecture

Codex sees one stable MCP server through the repo-owned `open-computer-use`
plugin:

```toml
[plugins."open-computer-use@homelab-local"]
enabled = true
```

The plugin's bundled MCP config points at
`/run/current-system/sw/bin/codex-computer-use-mcp`.

That broker owns temporary desktop capsules:

```text
Codex
  -> codex-computer-use-mcp
    -> codex-desktop start/list/stop
      -> Xvfb + DBus + AT-SPI + openbox + x11vnc + noVNC
      -> open-computer-use mcp inside that desktop session
```

The important rule is that `open-computer-use` runs inside the graphical session
it controls. Do not run it as a detached system service and expect it to see
arbitrary VNC sessions.

## Commands

Start a browser desktop:

```bash
codex-desktop start
```

Start a blank desktop:

```bash
codex-desktop start --profile blank
```

Start a custom command inside the desktop:

```bash
codex-desktop start --profile none -- chromium --no-first-run about:blank
```

List desktops:

```bash
codex-desktop list
codex-desktop list --json
```

Inspect one desktop:

```bash
codex-desktop status <desktop-id>
codex-desktop env <desktop-id>
```

Run a command in the desktop session:

```bash
codex-desktop exec <desktop-id> -- open-computer-use call list_apps
```

Stop a desktop:

```bash
codex-desktop stop <desktop-id>
```

Remove stopped or exited runtime directories:

```bash
codex-desktop prune
```

## MCP Tools

The broker exposes lifecycle tools:

- `desktop_start`
- `desktop_list`
- `desktop_status`
- `desktop_vnc_url`
- `desktop_stop`

It also proxies the Open Computer Use tools into the selected desktop:

- `list_apps`
- `get_app_state`
- `click`
- `perform_secondary_action`
- `scroll`
- `drag`
- `type_text`
- `press_key`
- `set_value`

If a Computer Use tool is called without `desktop_id` and exactly one desktop is
running, that desktop is used. If no desktop is running, the broker starts a
browser desktop automatically. If multiple desktops are running, pass
`desktop_id` explicitly.

## Verification

After switching the NixOS generation:

```bash
codex-desktop start --json
codex-desktop list
codex-desktop exec <desktop-id> -- open-computer-use call list_apps
codex-desktop stop <desktop-id>
```

For MCP-level validation, restart `codex-remote-control.service` after the new
config is seeded and ask Codex to call `desktop_start`, then `list_apps`.

## Network Notes

The desktop's VNC and noVNC listeners bind to `127.0.0.1` by default. This keeps
temporary desktops private to the server and Codex process. If a human needs to
view one from another machine, tunnel the printed noVNC port over SSH or change
`CODEX_DESKTOP_LISTEN_HOST` / `CODEX_DESKTOP_PUBLIC_HOST` in the managed service
environment.

Do not expose these temporary desktops publicly without authentication.
