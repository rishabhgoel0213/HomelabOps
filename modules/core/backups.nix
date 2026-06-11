{ config, lib, pkgs, ... }:

let
  cfg = config.homelab;
in
{
  config = lib.mkIf cfg.backups.enable {
    services.restic.backups.homelab = {
      initialize = true;
      repository = cfg.backups.repository;
      passwordFile = config.sops.secrets."restic-password".path;
      environmentFile = config.sops.secrets."restic.env".path;
      paths = [
        "/srv/ops"
        "/srv/state"
        "/etc/nixos"
        "/home/rishabh/.codex"
      ];
      exclude = [
        "/home/rishabh/.codex/log"
        "/home/rishabh/.codex/app-server-daemon/*.log"
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
    ];
  };
}
