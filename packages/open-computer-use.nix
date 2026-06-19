{
  at-spi2-core,
  buildGoModule,
  fetchFromGitHub,
  gobject-introspection,
  gtk3,
  lib,
  makeWrapper,
  python3,
  python3Packages,
}:

let
  python = python3.withPackages (ps: [ ps.pygobject3 ]);
  giTypelibPath = lib.makeSearchPath "lib/girepository-1.0" [
    at-spi2-core
    gobject-introspection
    gtk3
  ];
  libraryPath = lib.makeLibraryPath [
    at-spi2-core
    gtk3
    gobject-introspection
  ];
  dataDirs = lib.makeSearchPath "share" [
    at-spi2-core
    gobject-introspection
    gtk3
  ];
in
buildGoModule rec {
  pname = "open-computer-use";
  version = "0.1.53";

  src = fetchFromGitHub {
    owner = "iFurySt";
    repo = "open-codex-computer-use";
    rev = "v${version}";
    hash = "sha256-jcVPTOb68rAh6fPenatLotAugRAoan6hVYah6l70/iw=";
  };

  sourceRoot = "${src.name}/apps/OpenComputerUseLinux";
  vendorHash = null;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    if [[ -x "$out/bin/OpenComputerUseLinux" ]]; then
      mv "$out/bin/OpenComputerUseLinux" "$out/bin/open-computer-use"
    elif [[ -x "$out/bin/opencomputeruselinux" ]]; then
      mv "$out/bin/opencomputeruselinux" "$out/bin/open-computer-use"
    elif [[ ! -x "$out/bin/open-computer-use" ]]; then
      first_binary="$(find "$out/bin" -mindepth 1 -maxdepth 1 -type f -perm -0100 -print -quit)"
      if [[ -z "$first_binary" ]]; then
        echo "Could not find built Open Computer Use binary" >&2
        exit 1
      fi
      mv "$first_binary" "$out/bin/open-computer-use"
    fi

    wrapProgram "$out/bin/open-computer-use" \
      --prefix PATH : "${lib.makeBinPath [ python ]}" \
      --prefix GI_TYPELIB_PATH : "${giTypelibPath}" \
      --prefix LD_LIBRARY_PATH : "${libraryPath}" \
      --prefix XDG_DATA_DIRS : "${dataDirs}"
  '';

  meta = {
    description = "Open Computer Use Linux MCP server and CLI";
    homepage = "https://github.com/iFurySt/open-codex-computer-use";
    license = lib.licenses.mit;
    mainProgram = "open-computer-use";
    platforms = lib.platforms.linux;
  };
}
