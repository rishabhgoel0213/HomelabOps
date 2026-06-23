{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab;
  eden = pkgs.callPackage ../../packages/eden.nix { };
  edenState = "${cfg.paths.stateRoot}/eden";
  edenPort = 6097;

  runtimePath = lib.makeBinPath (
    with pkgs;
    [
      bash
      coreutils
      dbus
      findutils
      gawk
      gnugrep
      gnused
      iproute2
      novnc
      openbox
      procps
      python3
      python3Packages.websockify
      util-linux
      x11vnc
      xdpyinfo
      xterm
      xorg-server
    ]
  );

  edenDesktop = pkgs.stdenvNoCC.mkDerivation {
    pname = "eden-desktop";
    version = "0.1.0";
    dontUnpack = true;
    nativeBuildInputs = [ pkgs.makeWrapper ];
    installPhase = ''
      install -Dm0755 ${../../scripts/eden-desktop} "$out/bin/eden-desktop"
      patchShebangs "$out/bin"
      wrapProgram "$out/bin/eden-desktop" \
        --prefix PATH : "${runtimePath}" \
        --set-default EDEN_EXECUTABLE "${eden}/bin/eden" \
        --set-default EDEN_DESKTOP_USER "rishabh" \
        --set-default EDEN_DESKTOP_GROUP "users" \
        --set-default EDEN_STATE_ROOT "${edenState}" \
        --set-default EDEN_LISTEN_HOST "127.0.0.1" \
        --set-default EDEN_DISPLAY ":87" \
        --set-default EDEN_VNC_PORT "5997" \
        --set-default EDEN_WEB_PORT "${toString edenPort}" \
        --set-default EDEN_WIDTH "1920" \
        --set-default EDEN_HEIGHT "1080" \
        --set-default EDEN_NOVNC_WEB_ROOT "${pkgs.novnc}/share/webapps/novnc" \
        --set-default EDEN_XORG_MODULE_PATH "${config.hardware.nvidia.package.bin}/lib/xorg/modules,${pkgs.xorg-server}/lib/xorg/modules" \
        --set-default VK_ICD_FILENAMES "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json"
    '';
  };
in
{
  config = lib.mkIf cfg.eden.enable {
    environment.systemPackages = [
      eden
      edenDesktop
    ];

    users.users.rishabh.extraGroups = [
      "render"
      "video"
    ];

    systemd.tmpfiles.rules = [
      "d ${edenState} 0700 rishabh users - -"
      "d ${edenState}/home 0700 rishabh users - -"
      "d ${edenState}/runtime 0700 rishabh users - -"
      "d ${edenState}/config 0700 rishabh users - -"
      "d ${edenState}/cache 0700 rishabh users - -"
      "d ${edenState}/data 0700 rishabh users - -"
      "d ${edenState}/log 0700 rishabh users - -"
      "d ${edenState}/games 0750 rishabh users - -"
    ];

    systemd.services.eden-switch = {
      description = "Eden Switch emulator private noVNC desktop";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      unitConfig.ConditionPathExists = "/proc/driver/nvidia/version";
      path = [
        eden
        edenDesktop
        pkgs.bash
        pkgs.coreutils
        pkgs.dbus
        pkgs.iproute2
        pkgs.novnc
        pkgs.openbox
        pkgs.procps
        pkgs.python3
        pkgs.python3Packages.websockify
        pkgs.util-linux
        pkgs.x11vnc
        pkgs.xdpyinfo
        pkgs.xorg-server
      ];
      environment = {
        EDEN_EXECUTABLE = "${eden}/bin/eden";
        EDEN_DESKTOP_USER = "rishabh";
        EDEN_DESKTOP_GROUP = "users";
        EDEN_STATE_ROOT = edenState;
        EDEN_LISTEN_HOST = "127.0.0.1";
        EDEN_DISPLAY = ":87";
        EDEN_VNC_PORT = "5997";
        EDEN_WEB_PORT = toString edenPort;
        EDEN_WIDTH = "1920";
        EDEN_HEIGHT = "1080";
        EDEN_NOVNC_WEB_ROOT = "${pkgs.novnc}/share/webapps/novnc";
        EDEN_XORG_MODULE_PATH = "${config.hardware.nvidia.package.bin}/lib/xorg/modules,${pkgs.xorg-server}/lib/xorg/modules";
        GBM_BACKEND = "nvidia-drm";
        QT_QPA_PLATFORM = "xcb";
        SDL_VIDEODRIVER = "x11";
        VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      };
      serviceConfig = {
        ExecStart = "${edenDesktop}/bin/eden-desktop";
        SupplementaryGroups = [
          "render"
          "video"
        ];
        Restart = "on-failure";
        RestartSec = "5s";
        WorkingDirectory = "${edenState}/games";
      };
    };

    homelab.routes.switch = {
      enable = true;
      host = "switch";
      visibility = "internal";
      upstream = "http://127.0.0.1:${toString edenPort}";
      description = "Eden Switch emulator private noVNC desktop";
      extraConfig = ''
        redir / /vnc.html?autoconnect=1&resize=scale&reconnect=1&path=websockify&encrypt=1 302
        header {
          X-Robots-Tag "noindex, nofollow"
        }
      '';
    };

    assertions = [
      {
        assertion = cfg.acme.enable;
        message = "homelab.eden.enable requires homelab.acme.enable for trusted internal HTTPS.";
      }
    ];
  };
}
