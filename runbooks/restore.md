# Restore Runbook

## List Snapshots

```bash
sudo restic snapshots
```

## Restore To A Temporary Directory

```bash
sudo mkdir -p /srv/restore-test
sudo restic restore latest --target /srv/restore-test
```

## Restore A Service State Directory

Stop the service, restore into a temporary directory, inspect it, then replace the state directory:

```bash
sudo systemctl stop vaultwarden.service
sudo restic restore latest --target /srv/restore-test --include /srv/state/vaultwarden
```

Do not overwrite live state without inspecting the restored files first.
