{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  nativeBuildInputs = [
    (import ./roc-lang_compiler.nix { inherit pkgs; })
  ];
}
