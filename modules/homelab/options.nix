{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkOption types;
in
{
  options.homelab = {
    domain = mkOption {
      type = types.str;
      description = "Base public domain for this server.";
    };

    internalSubdomain = mkOption {
      type = types.str;
      default = "internal";
      description = "Subdomain used for tailnet-only applications.";
    };

    internalDomain = mkOption {
      type = types.str;
      readOnly = true;
      description = "Fully qualified internal domain.";
    };

    tailnetIp = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Stable Tailscale IPv4 address for this host.";
    };

    acme = {
      enable = mkEnableOption "wildcard ACME certificates through Cloudflare DNS";
      email = mkOption {
        type = types.str;
        description = "Email address used for ACME registration.";
      };
    };

    secrets.enable = mkEnableOption "sops-nix managed server secrets";

    publicTunnel = {
      enable = mkEnableOption "Cloudflare Tunnel public wildcard ingress";
      tunnelId = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Cloudflare Tunnel UUID.";
      };
    };

    privateDns.enable = mkEnableOption "CoreDNS wildcard DNS for internal tailnet apps";

    backups = {
      enable = mkEnableOption "scheduled restic backups";
      repository = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Restic repository, for example an sftp: URL or local path.";
      };
      sshTarget = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Optional SSH target for restic SFTP repositories, for example u123456@u123456.your-storagebox.de.";
      };
      sshPort = mkOption {
        type = types.port;
        default = 23;
        description = "SSH port for the restic SFTP command. Hetzner Storage Boxes commonly use port 23.";
      };
    };

    vaultwarden.enable = mkEnableOption "Vaultwarden private password vault";
    backrest.enable = mkEnableOption "Backrest private restic web UI";
    syncthing.enable = mkEnableOption "Syncthing private file sync";
    samba.enable = mkEnableOption "Private SMB file share";

    routes = mkOption {
      default = { };
      description = "Declarative HTTP route registry.";
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              enable = mkOption {
                type = types.bool;
                default = true;
                description = "Whether this route is published.";
              };

              host = mkOption {
                type = types.str;
                default = name;
                description = "Subdomain label, @ for the apex, or a full hostname.";
              };

              fqdn = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Optional fully qualified hostname override.";
              };

              visibility = mkOption {
                type = types.enum [
                  "internal"
                  "public"
                  "public-protected"
                ];
                default = "internal";
                description = "Which ingress lane serves this route.";
              };

              upstream = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Reverse proxy upstream, such as http://127.0.0.1:3000.";
              };

              upstreamHostHeader = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Optional Host header value to send to the reverse proxy upstream.";
              };

              redirectTo = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Redirect target, such as https://home.example.com{uri}.";
              };

              redirectStatus = mkOption {
                type = types.int;
                default = 308;
                description = "HTTP status code used when redirectTo is set.";
              };

              root = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Static file root served by Caddy.";
              };

              response = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Static response body for simple placeholder routes.";
              };

              status = mkOption {
                type = types.int;
                default = 200;
                description = "HTTP status for response routes.";
              };

              extraConfig = mkOption {
                type = types.lines;
                default = "";
                description = "Extra Caddy directives appended to this route.";
              };

              description = mkOption {
                type = types.str;
                default = "";
                description = "Human-readable route note.";
              };
            };
          }
        )
      );
    };

    routeTable = mkOption {
      type = types.attrs;
      default = { };
      description = "Computed route table for status commands.";
    };
  };

  config.homelab.internalDomain = "${config.homelab.internalSubdomain}.${config.homelab.domain}";
}
