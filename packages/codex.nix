{
  codex,
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

let
  version = "0.139.0";
  srcHash = "sha256-XjzlkBUkBey+P3tFLDYB3ae5oseUfW5tmzhLzqlqj2E=";
  cargoHash = "sha256-8mN4OTRJvt2mBYHQXZS55PSOChLqEIiXwPu2y+2MZ9o=";
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
    substituteInPlace Cargo.toml \
      --replace-fail 'lto = "thin"' "" \
      --replace-fail 'codegen-units = 1' ""
  '';
})
