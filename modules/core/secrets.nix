{ config, lib, pkgs, ... }:

let
  cfg = config.homelab;
in
{
  config = lib.mkIf cfg.secrets.enable {
    sops = {
      defaultSopsFile = ../../secrets/homelab.yaml;
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
      };
    };
  };
}
