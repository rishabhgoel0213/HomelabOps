{ config, lib, pkgs, ... }:

let
  cfg = config.homelab;
in
{
  systemd.tmpfiles.rules = [
    "d ${cfg.paths.publicSiteState} 0755 caddy caddy - -"
  ];

  homelab.routes.home = {
    enable = true;
    host = "home";
    visibility = "public";
    root = cfg.paths.publicSiteState;
    extraConfig = "@resumeAliases path /resume.pdf /Resume.pdf\nredir @resumeAliases /rishabh-goel-resume.pdf 308";
    description = "Public personal website served through Cloudflare Tunnel";
  };

  homelab.routes.apex = {
    enable = true;
    host = "@";
    visibility = "public";
    redirectTo = "https://home.${cfg.domain}{uri}";
    description = "Apex redirect to the public personal website";
  };

  homelab.routes.www = {
    enable = true;
    host = "www";
    visibility = "public";
    redirectTo = "https://home.${cfg.domain}{uri}";
    description = "www redirect to the public personal website";
  };
}
