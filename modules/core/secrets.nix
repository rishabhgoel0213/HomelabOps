{ config, lib, pkgs, ... }:

let
  cfg = config.homelab;
in
{
  config = lib.mkIf cfg.secrets.enable {
    sops = {
      defaultSopsFile = /srv/ops/secrets/homelab.yaml;
      validateSopsFiles = false;
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

      secrets = {
        "cloudflare-admin.env" = {
          owner = "rishabh";
          group = "users";
          mode = "0400";
        };
        "cloudflare-dns.env" = { };
        "cloudflared-tunnel.json" = { };
        "tailscale-oauth.env" = {
          owner = "rishabh";
          group = "users";
          mode = "0400";
        };
        "vaultwarden.env" = { };
        "restic-password" = { };
        "restic.env" = { };
      }
      // lib.optionalAttrs (cfg.backups.sshTarget != null) {
        "restic-ssh-key" = {
          owner = "root";
          group = "root";
          mode = "0400";
        };
        "restic-known-hosts" = {
          owner = "root";
          group = "root";
          mode = "0444";
        };
      };
    };
  };
}
