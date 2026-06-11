{ config, lib, pkgs, ... }:

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
      CODEX_HOME = "/home/rishabh/.codex";
      HOME = "/home/rishabh";
    };
    serviceConfig = {
      Type = "simple";
      User = "rishabh";
      Group = "users";
      WorkingDirectory = "/srv/ops";
      ExecStartPre = "${pkgs.coreutils}/bin/test -x /home/rishabh/.codex/packages/standalone/current/codex";
      ExecStart = "/home/rishabh/.codex/packages/standalone/current/codex app-server --remote-control --listen unix://";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
