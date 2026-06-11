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

    ../../modules/services/vaultwarden.nix
    ../../modules/services/backrest.nix
    ../../modules/services/public-site.nix

    ../../routes
  ];

  homelab = {
    domain = "therealrishabh.com";
    internalSubdomain = "internal";

    # Fill this with `tailscale ip -4` before enabling private DNS.
    tailnetIp = null;

    acme = {
      enable = false;
      email = "rishabhgoel0213@gmail.com";
    };

    secrets.enable = false;

    publicTunnel = {
      enable = false;
      tunnelId = null;
    };

    privateDns.enable = false;

    backups = {
      enable = false;
      repository = null;
    };

    vaultwarden.enable = false;
    backrest.enable = false;
  };

  system.stateVersion = "26.05";
}
