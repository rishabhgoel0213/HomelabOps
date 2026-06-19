# Codex Workspace

This directory is the default cockpit for Codex work on `nixos-pc`.

Useful paths:

- `/srv/ops` - declarative NixOS and homelab source of truth.
- `/srv/state` - durable runtime state.
- `/srv/state/codex` - managed Codex runtime home.
- `/srv/workspace/repos` - checked out or generated repositories.
- `/srv/workspace/scratch` - disposable experiments.
- `/srv/workspace/docs` - server context for future chats.

Common starts:

```bash
nix develop /srv/workspace
cd /srv/ops && just status
cd /srv/ops && just routes
```

For one-off tools:

```bash
nix shell --inputs-from /srv/ops nixpkgs#jq --command jq --version
```

