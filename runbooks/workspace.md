# Codex Workspace Runbook

The shared workspace is:

```text
/srv/workspace
```

The ops-owned scaffold source is:

```text
/srv/ops/workspace
```

Sync the scaffold after changing workspace docs, scripts, or the shell:

```bash
cd /srv/ops
just workspace-sync
```

The sync creates common directories, copies the scaffold, and initializes a local
Git repository in `/srv/workspace` so chats launched in subdirectories inherit
the root `AGENTS.md`.

Runtime Codex configuration still comes from:

```text
/srv/ops/codex/config.toml
```

The managed Codex runtime home is:

```text
/srv/state/codex
```

