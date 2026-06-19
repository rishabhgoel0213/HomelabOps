# Nix Usage

Nix is the default way to get tools on this server.

## Workspace Shell

Use the shared shell when starting broad workspace tasks:

```bash
nix develop /srv/workspace
```

The workspace shell follows the pinned `nixpkgs` from `/srv/ops`.

## One-Off Tools

Use temporary shells instead of installing global packages:

```bash
nix shell --inputs-from /srv/ops nixpkgs#jq --command jq --version
nix shell --inputs-from /srv/ops nixpkgs#nodejs --command node --version
```

The helper script sets a writable cache location:

```bash
/srv/workspace/scripts/with-nix shell --inputs-from /srv/ops nixpkgs#jq --command jq --version
```

## Ops Repo Checks

From `/srv/ops`:

```bash
just check
just build
just test
just routes
```

Use `just switch` only when the user wants the host changed.

## Sandbox Notes

Some Codex sessions run with a restricted filesystem or blocked network. If Nix
fails with cache, daemon socket, or network errors:

1. Retry with `XDG_CACHE_HOME=/tmp/codex-nix-cache` if the error is only a user
   cache write.
2. If Nix needs `/nix/var/nix/daemon-socket/socket`, a substituter download, or a
   NixOS switch, request scoped approval for the exact command.
3. Do not work around Nix by installing tools through unrelated package managers.

## Durable Host Changes

Durable server changes belong in `/srv/ops`, usually in:

- `hosts/nixos-pc/default.nix` for host-level feature toggles.
- `modules/core/*.nix` for core platform behavior.
- `modules/services/*.nix` for service modules.
- `modules/homelab/*.nix` for shared homelab options and ingress.
- `routes/apps.json` for user-managed reverse-proxy routes.

