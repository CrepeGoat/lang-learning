{
  # source code repo
  src,
  # nix stdlib
  lib,
  rustPlatform,
  # dependencies
  python3,
  python3Packages,
  runt,
  jq,
  z3,
  cvc5,
  whichSmt ? "z3",
}:

let
  srcTomlMeta = (builtins.fromTOML (builtins.readFile "${src}/Cargo.toml")).workspace.package;
  smt =
    if (whichSmt == "z3") then
      z3
    else if (whichSmt == "cvc5") then
      cvc5
    else
      throw "invalid value for `whichSmt`; must be either \"z3\" or \"cvc5\"";
in
rustPlatform.buildRustPackage {
  pname = "filament";
  version = srcTomlMeta.version;

  src = src;
  cargoPatches = [ ./add-Cargo.lock.patch ];
  cargoHash = "sha256-VMsjEP4/ivVe2UrXuZvMuiEhIr8RruHOX/e2kL0CJgU=";

  nativeBuildInputs = [
    python3
    python3Packages.numpy
    runt
    jq
    smt
  ];

  patches = [ ./runt.toml.patch ];
  doCheck = false;
  doInstallCheck = true;
  installCheckPhase = ''
    ln -s $out ./result
    runt -d
    rm ./result
  '';

  meta = {
    description = srcTomlMeta.description;
    homepage = srcTomlMeta.homepage;
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
