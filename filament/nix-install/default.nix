let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
  pkgs = import nixpkgs { };
  src = pkgs.fetchFromGitHub {
    owner = "cucapra";
    repo = "filament";
    rev = "bb771f1b470b31178b68d238844995de159b7f30";
    hash = "sha256-pHG0H4e6DieZSV+qiDHcmq1i4+CdqDJOfIAQnGmxba8=";
  };
  runt = pkgs.callPackage ./runt/package.nix { };
in
pkgs.callPackage ./package.nix {
  src = src;
  runt = runt;
}
