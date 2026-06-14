# Backups Runbook

Backrest owns scheduled backups, retention, monitoring, and restores. Restic is
still the backup engine underneath, but there is no separate NixOS Restic timer
for this repository.

The Hetzner Storage Box repository is:

```text
sftp:hetzner-storage-box:/home/restic/nixos-pc
```

Use this repository URI in Backrest. `hetzner-storage-box` is an SSH alias
mounted into the Backrest container at `/root/.ssh/config`.

The already-initialized Restic repository password is stored in sops as:

```text
restic-password
```

## Backrest UI Setup

Open:

```text
https://backups.internal.therealrishabh.com
```

Add or import a repository:

- Repository URI: `sftp:hetzner-storage-box:/home/restic/nixos-pc`
- Password: value of `restic-password` from sops
- Optional flags: none required

Then create a plan with these paths:

```text
/backup/home/rishabh
/backup/srv/ops
/backup/srv/state
/backup/etc/nixos
```

Suggested excludes:

```text
/backup/home/rishabh/.cache
/backup/home/rishabh/.codex/.tmp
/backup/home/rishabh/.codex/cache
/backup/home/rishabh/.codex/log
/backup/home/rishabh/.codex/tmp
/backup/home/rishabh/.codex/app-server-daemon/*.log
/backup/home/rishabh/.local/share/Trash
/backup/srv/state/backrest
/backup/srv/state/backrest/cache
/backup/srv/state/backrest/tmp
/backup/srv/state/syncthing/index-v2
```

Suggested backup flags:

```text
--host=nixos-pc
```

Suggested schedule:

```text
15 2 * * *
```

Suggested retention:

```text
14 daily
8 weekly
12 monthly
```

Create a second plan for quarter-boundary archives:

```text
Plan ID: nixos-pc-quarterly
Schedule: 15 3 1 1,4,7,10 *
Retention: keep all
```

This plan uses the same repository, paths, excludes, and backup flags as the
daily plan. Its snapshots are tagged separately as `plan:nixos-pc-quarterly` and
are intended to be kept indefinitely.

Suggested repository maintenance:

```text
Prune: 0 0 1 * *, max unused 10%
Check: 0 0 1 * *
Repo-wide forget: disabled
```

## Secret Material

Nix stores the repository connection settings under `homelab.backrest`:

```nix
homelab.backrest = {
  enable = true;
  repository = "sftp:u614006@u614006.your-storagebox.de:/home/restic/nixos-pc";
  sshTarget = "u614006@u614006.your-storagebox.de";
  sshPort = 23;
};
```

Backrest gets SSH credentials from sops-managed files:

```text
restic-ssh-key
restic-known-hosts
```

NixOS copies them into:

```text
/srv/state/backrest/ssh
```

and mounts that directory read-only into the container as:

```text
/root/.ssh
```
