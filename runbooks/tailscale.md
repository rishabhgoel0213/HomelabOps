# Tailscale Runbook

## Control Model

Tailscale node state is controlled with the normal `tailscale` CLI. Tailnet
admin state is controlled with `tsctl`, which uses encrypted OAuth client
credentials from `sops`.

## OAuth Client

Tailscale does not provide a user-login authorization flow for arbitrary local
automation. Create a tailnet-owned OAuth client in the admin console:

```text
https://login.tailscale.com/admin/settings/oauth
```

For internal DNS automation, grant:

```text
DNS: Read
DNS: Write
```

For broader Codex-driven tailnet administration, add the other scopes you want
Codex to manage. Prefer starting narrow and expanding deliberately.

Tailscale shows the OAuth client secret once. Store it immediately in Apple
Passwords/Vaultwarden, then run:

```bash
~/store-tailscale-oauth
```

Verify:

```bash
just tailscale-verify
just tailscale-dns
```

## Current Internal DNS Target

The server's Tailscale IPv4 is:

```text
100.73.159.103
```

The intended split DNS route is:

```text
internal.therealrishabh.com -> 100.73.159.103
```
