{ config, lib, pkgs, ... }:

let
  cfg = config.homelab;
  codexHome = cfg.paths.codexHome;
  codexPackage = pkgs.callPackage ../../packages/codex.nix { };
  codexBin = "${codexPackage}/bin/codex";
  codexWrapper = pkgs.writeShellScriptBin "codex" ''
    export CODEX_HOME=${lib.escapeShellArg codexHome}
    export HOME=${lib.escapeShellArg cfg.paths.userHome}
    exec ${codexBin} "$@"
  '';
  prepareCodexHome = pkgs.writeShellScript "prepare-codex-home" ''
    set -euo pipefail

    install -d -m 0700 -o rishabh -g users ${lib.escapeShellArg codexHome}
    install -d -m 0700 -o rishabh -g users \
      ${lib.escapeShellArg "${codexHome}/cache"} \
      ${lib.escapeShellArg "${codexHome}/log"} \
      ${lib.escapeShellArg "${codexHome}/plugins"} \
      ${lib.escapeShellArg "${codexHome}/tmp"}

    if [[ -r ${lib.escapeShellArg cfg.paths.codexConfigSource} ]]; then
      install -m 0600 -o rishabh -g users \
        ${lib.escapeShellArg cfg.paths.codexConfigSource} \
        ${lib.escapeShellArg "${codexHome}/config.toml"}
    fi

    ${lib.optionalString cfg.secrets.enable ''
      if [[ -r ${lib.escapeShellArg config.sops.secrets."codex-auth.json".path} ]]; then
        install -m 0600 -o rishabh -g users \
          ${lib.escapeShellArg config.sops.secrets."codex-auth.json".path} \
          ${lib.escapeShellArg "${codexHome}/auth.json"}
      fi
      if [[ -r ${lib.escapeShellArg config.sops.secrets."codex-credentials.json".path} ]]; then
        install -m 0600 -o rishabh -g users \
          ${lib.escapeShellArg config.sops.secrets."codex-credentials.json".path} \
          ${lib.escapeShellArg "${codexHome}/.credentials.json"}
      fi
    ''}
  '';
in
{
  environment.systemPackages = [ codexWrapper ];

  environment.sessionVariables = {
    CODEX_HOME = codexHome;
  };

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
    ] ++ lib.optional cfg.secrets.enable "sops-nix.service";
    path = with pkgs; [
      bubblewrap
      coreutils
      git
      just
      nix
      openssh
      ripgrep
    ];
    environment = {
      CODEX_HOME = codexHome;
      HOME = cfg.paths.userHome;
    };
    serviceConfig = {
      Type = "simple";
      User = "rishabh";
      Group = "users";
      WorkingDirectory = cfg.paths.opsRoot;
      ExecStartPre = "${prepareCodexHome}";
      ExecStart = "${codexBin} app-server --remote-control --listen unix://";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
