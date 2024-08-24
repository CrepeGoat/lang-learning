{
  lib,
  # stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "runt";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "rachitnigam";
    repo = "runt";
    rev = "2448532b6f4501e5fc55f2762a9e7d3a7c529318";
    hash = "sha256-Lk1u+JNdX/vRXDZAhT12E2cePfT4mFR6WOgfsppjIdg=";
  };

  cargoPatches = [ ./add-Cargo.lock.patch ];
  cargoHash = "sha256-nyt6TTJKJAep6jGzph4zUEqZ7BZ9Mvlv7SNGG+cNbns=";
  doCheck = false;

  meta = with lib; {
    description = "A lighweight and parallel snapshot testing framework in Rust";
    documentation = "https://docs.rs/runt/latest/runt/";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
