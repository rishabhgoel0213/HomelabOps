{ config, lib, pkgs, ... }:

let
  cfg = config.homelab;
  hasSftpSshTarget = cfg.backups.sshTarget != null;
  resticSftpOption =
    "sftp.command='ssh ${cfg.backups.sshTarget} -p ${toString cfg.backups.sshPort} -i ${config.sops.secrets."restic-ssh-key".path} -o BatchMode=yes -o IdentitiesOnly=yes -o UserKnownHostsFile=${config.sops.secrets."restic-known-hosts".path} -o StrictHostKeyChecking=yes -s sftp'";
in
{
  config = lib.mkIf cfg.backups.enable {
    services.restic.backups.homelab = {
      initialize = true;
      repository = cfg.backups.repository;
      passwordFile = config.sops.secrets."restic-password".path;
      environmentFile = config.sops.secrets."restic.env".path;
      extraOptions = lib.optionals hasSftpSshTarget [
        resticSftpOption
      ];
      extraBackupArgs = [
        "--exclude-caches"
        "--one-file-system"
        "--tag homelab"
      ];
      paths = [
        "/srv/ops"
        "/srv/state"
        "/etc/nixos"
        "/home/rishabh"
      ];
      exclude = [
        "/home/rishabh/.cache"
        "/home/rishabh/.codex/.tmp"
        "/home/rishabh/.codex/cache"
        "/home/rishabh/.codex/log"
        "/home/rishabh/.codex/tmp"
        "/home/rishabh/.codex/app-server-daemon/*.log"
        "/home/rishabh/.local/share/Trash"
        "/srv/state/backrest/cache"
      ];
      pruneOpts = [
        "--keep-daily 14"
        "--keep-weekly 8"
        "--keep-monthly 12"
      ];
      timerConfig = {
        OnCalendar = "02:15";
        RandomizedDelaySec = "2h";
        Persistent = true;
      };
    };

    assertions = [
      {
        assertion = cfg.secrets.enable;
        message = "homelab.backups.enable requires homelab.secrets.enable for restic credentials.";
      }
      {
        assertion = cfg.backups.repository != null;
        message = "homelab.backups.repository must be set before enabling backups.";
      }
      {
        assertion = hasSftpSshTarget -> lib.hasPrefix "sftp:" cfg.backups.repository;
        message = "homelab.backups.sshTarget is only intended for restic sftp: repositories.";
      }
    ];
  };
}
