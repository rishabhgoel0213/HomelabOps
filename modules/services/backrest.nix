{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;

  cfg = config.homelab;
  backrestOwnsHetznerBackups = cfg.backups.repository != null && cfg.backups.sshTarget != null;
  sshTargetParts = lib.splitString "@" (cfg.backups.sshTarget or "");
  sshTargetIsUserHost = builtins.length sshTargetParts == 2;
  sshUser = if sshTargetIsUserHost then builtins.elemAt sshTargetParts 0 else "";
  sshHost = if sshTargetIsUserHost then builtins.elemAt sshTargetParts 1 else "";
in
{
  config = lib.mkIf cfg.backrest.enable {
    systemd.tmpfiles.rules = [
      "d /srv/state/backrest 0700 root root - -"
      "d /srv/state/backrest/ssh 0700 root root - -"
      "d /srv/state/backrest/tmp 0700 root root - -"
      "d /srv/state/backrest/cache 0700 root root - -"
    ];

    systemd.services.backrest-ssh-config = mkIf backrestOwnsHetznerBackups {
      description = "Prepare SSH config for Backrest Restic SFTP repositories";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      path = with pkgs; [
        coreutils
      ];
      script = ''
        install -d -m 0700 -o root -g root /srv/state/backrest/ssh
        install -m 0600 -o root -g root ${config.sops.secrets."restic-ssh-key".path} /srv/state/backrest/ssh/restic-ssh-key
        install -m 0644 -o root -g root ${config.sops.secrets."restic-known-hosts".path} /srv/state/backrest/ssh/known_hosts
        cat > /srv/state/backrest/ssh/config <<'EOF'
        Host hetzner-storage-box
          HostName ${sshHost}
          User ${sshUser}
          Port ${toString cfg.backups.sshPort}
          IdentityFile /root/.ssh/restic-ssh-key
          UserKnownHostsFile /root/.ssh/known_hosts
          StrictHostKeyChecking yes
          BatchMode yes
          IdentitiesOnly yes
        EOF
        chmod 0600 /srv/state/backrest/ssh/config
      '';
    };

    systemd.services.docker-backrest = mkIf backrestOwnsHetznerBackups {
      requires = [ "backrest-ssh-config.service" ];
      after = [ "backrest-ssh-config.service" ];
    };

    virtualisation.oci-containers.containers.backrest = {
      image = "garethgeorge/backrest:latest";
      autoStart = true;
      ports = [ "127.0.0.1:9898:9898" ];
      volumes = [
        "/srv/state/backrest:/data"
        "/srv/state/backrest/cache:/cache"
        "/srv/state/backrest/tmp:/tmp"
        "/srv/state/backrest/ssh:/root/.ssh:ro"
        "/srv/state:/srv/state:ro"
        "/srv/state:/backup/srv/state:ro"
        "/srv/ops:/backup/srv/ops:ro"
        "/etc/nixos:/backup/etc/nixos:ro"
        "/home/rishabh:/backup/home/rishabh:ro"
      ];
      environment = {
        BACKREST_CONFIG = "/data/config.json";
        BACKREST_DATA = "/data";
        XDG_CACHE_HOME = "/cache";
        TMPDIR = "/tmp";
        TZ = config.time.timeZone;
      };
      pull = "missing";
    };

    homelab.routes.backups = {
      enable = true;
      host = "backups";
      visibility = "internal";
      upstream = "http://127.0.0.1:9898";
      description = "Backrest restic UI";
    };

    assertions = [
      {
        assertion = cfg.acme.enable;
        message = "homelab.backrest.enable requires homelab.acme.enable for trusted internal HTTPS.";
      }
      {
        assertion = !backrestOwnsHetznerBackups || cfg.secrets.enable;
        message = "Backrest-managed Hetzner backups require homelab.secrets.enable for Restic SSH material.";
      }
      {
        assertion = !backrestOwnsHetznerBackups || sshTargetIsUserHost;
        message = "homelab.backups.sshTarget must be formatted as user@host for Backrest SSH config generation.";
      }
    ];
  };
}
