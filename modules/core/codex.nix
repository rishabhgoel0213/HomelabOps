{ config, lib, pkgs, ... }:

let
  cfg = config.homelab;
in
{
  systemd.services.codex-remote-control = {
    description = "Codex remote-control app server";
    restartIfChanged = false;
    wantedBy = [ "multi-user.target" ];
    wants = [
      "network-online.target"
      "tailscaled.service"
    ];
    after = [
      "network-online.target"
      "tailscaled.service"
    ];
    path = with pkgs; [
      bubblewrap
      codex
      coreutils
      git
      just
      nix
      openssh
      ripgrep
    ];
    environment = {
      CODEX_HOME = "${cfg.paths.userHome}/.codex";
      HOME = cfg.paths.userHome;
    };
    serviceConfig = {
      Type = "simple";
      User = "rishabh";
      Group = "users";
      WorkingDirectory = cfg.paths.opsRoot;
      ExecStartPre = "${pkgs.coreutils}/bin/test -x ${cfg.paths.userHome}/.codex/packages/standalone/current/codex";
      ExecStart = "${cfg.paths.userHome}/.codex/packages/standalone/current/codex app-server --remote-control --listen unix://";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
