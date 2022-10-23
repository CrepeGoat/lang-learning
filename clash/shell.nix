{ pkgs ? import <nixpkgs> { system = "x86_64-darwin"; } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.stack

    # required for clashi
    pkgs.libiconv
    pkgs.libffi
    pkgs.ncurses
  ];
}
