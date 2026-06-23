{
  appimage-run,
  fetchurl,
  lib,
  makeWrapper,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "eden";
  version = "0.2.1";

  src = fetchurl {
    url = "https://stable.eden-emu.dev/v${version}/Eden-Linux-v${version}-amd64-clang-pgo.AppImage";
    sha256 = "0vds4n5prsp02fc1j21q80dkfcdbj2mdnavji4cq6j06ifcbya3s";
  };

  dontUnpack = true;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm0755 "$src" "$out/lib/eden/Eden.AppImage"
    makeWrapper ${appimage-run}/bin/appimage-run "$out/bin/eden" \
      --add-flags "$out/lib/eden/Eden.AppImage"
  '';

  meta = {
    description = "Experimental open-source Nintendo Switch emulator";
    homepage = "https://eden-emu.dev/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "eden";
    platforms = [ "x86_64-linux" ];
  };
}
