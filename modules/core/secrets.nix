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
        "cloudflare-dns.env" = { };
        "cloudflared-tunnel.json" = { };
        "vaultwarden.env" = { };
        "restic-password" = { };
        "restic.env" = { };
      };
    };
  };
}
