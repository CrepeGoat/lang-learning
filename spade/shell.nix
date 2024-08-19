{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    
    # nativeBuildInputs is usually what you want -- tools you need to run
    buildInputs = [
      pkgs.libiconv  # for building spade compiler
    ];

    # shellHook = ''
    # ruff check --fix test/ && swim test
    # '';
}
