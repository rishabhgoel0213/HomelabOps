{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/homelab/options.nix
    ../../modules/homelab/ingress.nix

    ../../modules/core/base.nix
    ../../modules/core/codex.nix
    ../../modules/core/containers.nix
    ../../modules/core/filesystem.nix
    ../../modules/core/gpu.nix
    ../../modules/core/secrets.nix
    ../../modules/core/backups.nix
    ../../modules/core/dns.nix
    ../../modules/core/cloudflare.nix
    ../../modules/core/tailscale-api.nix

    ../../modules/services/vaultwarden.nix
    ../../modules/services/backrest.nix
    ../../modules/services/public-site.nix
    ../../modules/services/syncthing.nix
    ../../modules/services/samba.nix

    ../../routes
  ];

  homelab = {
    domain = "therealrishabh.com";
    internalSubdomain = "internal";

    tailnetIp = "100.73.159.103";

    acme = {
      enable = true;
      email = "rishabhgoel0213@gmail.com";
    };

    secrets.enable = true;

    publicTunnel = {
      enable = true;
      tunnelId = "b0bf2296-d35d-4d03-aca8-ee3d4ecaa8fa";
    };

    privateDns.enable = true;

    backups = {
      # Backrest owns backup scheduling, retention, and monitoring. Keep the
      # Hetzner repository settings here for shared secret/material setup, but
      # leave the standalone NixOS restic timer disabled.
      enable = false;
      repository = "sftp:u614006@u614006.your-storagebox.de:/home/restic/nixos-pc";
      sshTarget = "u614006@u614006.your-storagebox.de";
      sshPort = 23;
    };

    vaultwarden.enable = true;
    backrest.enable = true;
    syncthing.enable = true;
    samba.enable = true;
  };

  system.stateVersion = "26.05";
}
