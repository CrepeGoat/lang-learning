let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
  pkgs = import nixpkgs { };
  runt = pkgs.callPackage ./runt/package.nix { };
in
pkgs.callPackage ./package.nix { runt = runt; }
