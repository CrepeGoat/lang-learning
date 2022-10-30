{ pkgs ? import <nixpkgs> { system = "x86_64-darwin"; } }:

pkgs.mkShell {
  buildInputs = [
    (pkgs.agda.withPackages (ps: [ps.standard-library]))
    pkgs.emacs
    pkgs.mononoki
  ];
}