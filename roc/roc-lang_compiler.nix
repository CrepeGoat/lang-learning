{ pkgs ? import <nixpkgs> { } }:
let
  rocSystem = "macos_apple_silicon";
in
pkgs.stdenv.mkDerivation rec {
  src = builtins.fetchTarball {
    url = "https://github.com/roc-lang/roc/releases/download/nightly/roc_nightly-${rocSystem}-latest.tar.gz";
    sha256 = "1wqfkls2gp9r3xir7vgirv76mzkh6x74w3jrbl6p40y1ssain8pl";
  };
  name = "roc-lang_compiler";
  inherit (pkgs) system;

  dontConfigure = true;
  dontBuild = true;
  doCheck = true;
  checkPhase = "${src}/roc version";
  installPhase = ''
    mkdir $out
    mkdir $out/bin
    cp ${src}/roc $out/bin/roc
  '';
  dontFixup = true;
}
