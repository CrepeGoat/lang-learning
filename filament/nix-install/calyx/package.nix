{
  src,
  # nix stdlib
  lib,
  rustPlatform,
  # dependencies
  runt,
  fud,
}:
rustPlatform.buildRustPackage {
  pname = "calyx";
  version = "0.7.1";

  inherit src;
  cargoPatches = [
    ./Cargo.lock.patch
    ./cider-dap_Cargo.toml.patch
  ];
  cargoHash = "sha256-mMGkpUeWKqc2Srbtd1+3SYQjVCVRUU3VITfQohQDnfM=";

  nativeBuildInputs = [
    runt
    fud
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
