{ config, lib, pkgs, ... }:

let
  cfg = config.homelab;
in
{
  config = lib.mkIf cfg.publicTunnel.enable {
    services.cloudflared = {
      enable = true;
      tunnels.${cfg.publicTunnel.tunnelId} = {
        credentialsFile = config.sops.secrets."cloudflared-tunnel.json".path;
        default = "http_status:404";
        ingress = {
          "${cfg.domain}" = "http://127.0.0.1:8080";
          "*.${cfg.domain}" = "http://127.0.0.1:8080";
        };
      };
    };

    assertions = [
      {
        assertion = cfg.secrets.enable;
        message = "homelab.publicTunnel.enable requires homelab.secrets.enable for the tunnel credentials file.";
      }
      {
        assertion = cfg.publicTunnel.tunnelId != null;
        message = "homelab.publicTunnel.tunnelId must be set to the Cloudflare Tunnel UUID.";
      }
    ];
  };
}
