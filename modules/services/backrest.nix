{ config, lib, pkgs, ... }:

let
  cfg = config.homelab;
in
{
  config = lib.mkIf cfg.backrest.enable {
    virtualisation.oci-containers.containers.backrest = {
      image = "garethgeorge/backrest:latest";
      autoStart = true;
      ports = [ "127.0.0.1:9898:9898" ];
      volumes = [
        "/srv/state/backrest:/data"
        "/srv/state:/srv/state:ro"
        "/srv/backups:/srv/backups"
      ];
      pull = "newer";
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
    ];
  };
}
