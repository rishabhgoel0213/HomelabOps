{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab;
  computerUseState = "${cfg.paths.codexHome}/computer-use";
  openComputerUse = pkgs.callPackage ../../packages/open-computer-use.nix { };

  runtimePath = lib.makeBinPath (
    with pkgs;
    [
      at-spi2-core
      bash
      chromium
      coreutils
      dbus
      findutils
      gawk
      gnugrep
      gnused
      iproute2
      jq
      novnc
      openComputerUse
      openbox
      procps
      python3
      python3Packages.websockify
      util-linux
      x11vnc
      xdpyinfo
      xterm
      xvfb
    ]
  );

  computerUseScripts = pkgs.stdenvNoCC.mkDerivation {
    pname = "codex-computer-use-scripts";
    version = "0.1.0";
    dontUnpack = true;
    nativeBuildInputs = [ pkgs.makeWrapper ];
    installPhase = ''
      install -Dm0755 ${../../scripts/codex-desktop} "$out/bin/codex-desktop"
      install -Dm0755 ${../../scripts/codex-computer-use-mcp} "$out/bin/codex-computer-use-mcp"
      patchShebangs "$out/bin"
      wrapProgram "$out/bin/codex-desktop" \
        --prefix PATH : "${runtimePath}" \
        --set-default CODEX_COMPUTER_USE_STATE "${computerUseState}" \
        --set-default CODEX_AT_SPI_BUS_LAUNCHER "${pkgs.at-spi2-core}/libexec/at-spi-bus-launcher" \
        --set-default CODEX_DESKTOP_LISTEN_HOST "127.0.0.1" \
        --set-default CODEX_DESKTOP_PUBLIC_HOST "127.0.0.1"
      wrapProgram "$out/bin/codex-computer-use-mcp" \
        --prefix PATH : "${runtimePath}" \
        --set-default CODEX_COMPUTER_USE_STATE "${computerUseState}" \
        --set-default CODEX_DESKTOP_COMMAND "$out/bin/codex-desktop" \
        --set-default OPEN_COMPUTER_USE_COMMAND "${openComputerUse}/bin/open-computer-use" \
        --set-default CODEX_COMPUTER_USE_AUTO_START "1"
    '';
  };
in
{
  environment.systemPackages = [
    computerUseScripts
    openComputerUse
  ];

  systemd.tmpfiles.rules = [
    "d ${computerUseState} 0700 rishabh users - -"
    "d ${computerUseState}/desktops 0700 rishabh users - -"
    "d ${computerUseState}/log 0700 rishabh users - -"
  ];

  systemd.services.codex-remote-control = {
    path = [
      computerUseScripts
      openComputerUse
      pkgs.at-spi2-core
      pkgs.bash
      pkgs.chromium
      pkgs.coreutils
      pkgs.dbus
      pkgs.findutils
      pkgs.gawk
      pkgs.gnugrep
      pkgs.gnused
      pkgs.iproute2
      pkgs.jq
      pkgs.novnc
      pkgs.openbox
      pkgs.procps
      pkgs.python3
      pkgs.python3Packages.websockify
      pkgs.util-linux
      pkgs.x11vnc
      pkgs.xdpyinfo
      pkgs.xterm
      pkgs.xvfb
    ];
    environment = {
      CODEX_COMPUTER_USE_STATE = computerUseState;
      CODEX_AT_SPI_BUS_LAUNCHER = "${pkgs.at-spi2-core}/libexec/at-spi-bus-launcher";
      CODEX_DESKTOP_COMMAND = "${computerUseScripts}/bin/codex-desktop";
      OPEN_COMPUTER_USE_COMMAND = "${openComputerUse}/bin/open-computer-use";
      CODEX_COMPUTER_USE_AUTO_START = "1";
      CODEX_DESKTOP_LISTEN_HOST = "127.0.0.1";
      CODEX_DESKTOP_PUBLIC_HOST = "127.0.0.1";
    };
  };
}
