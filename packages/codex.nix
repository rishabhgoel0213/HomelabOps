{
  codex,
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

let
  version = "0.142.0";
  srcHash = "sha256-F8wlv0vSuljNFDgIzoeuVxvD0dk90z2FBtpBTMih7AA=";
  cargoHash = "sha256-fvEFNE12J6zaLZrN6oQB8X+jXoKPSCWrL17Sl28+7/c=";
in
codex.overrideAttrs (_old: rec {
  pname = "codex";
  inherit version;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${version}";
    hash = srcHash;
  };

  sourceRoot = "${src.name}/codex-rs";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src sourceRoot;
    hash = cargoHash;
  };

  postPatch = ''
    substituteInPlace $cargoDepsCopy/*/webrtc-sys-*/build.rs \
      --replace-fail "cargo:rustc-link-lib=static=webrtc" "cargo:rustc-link-lib=dylib=webrtc"
    for cargo_toml_line in 'lto = "thin"' 'codegen-units = 1'; do
      if grep -Fq "$cargo_toml_line" Cargo.toml; then
        substituteInPlace Cargo.toml --replace-fail "$cargo_toml_line" ""
      fi
    done
  '';
})
