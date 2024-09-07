{
  # nix stdlib
  lib,
  rustPlatform,
  fetchFromGitHub,
  # dependencies
  runt,
}:
rustPlatform.buildRustPackage rec {
  pname = "calyx";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "calyxir";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JZl+8JT/gngZ2Vunz7w3vP/iv3qxSw4jh8/C4SSHNd8=";
  };
  cargoPatches = [ ./update-Cargo.lock.patch ];
  cargoHash = "sha256-LcdiloeqBbNn0Uy+8K2igc95bBWQd0Rh1a6+ogG8ZXU=";

  nativeBuildInputs = [
    runt
  ];

  patches = [ ./runt.toml.patch ];
  doCheck = false;
  doInstallCheck = true;
  installCheckPhase = ''
    ln -s $out ./result
    runt -d
    rm ./result
  '';

  meta = with lib; {
    description = "A Compiler Infrastructure for Accelerator Generators";
    homepage = "https://calyxir.org";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
