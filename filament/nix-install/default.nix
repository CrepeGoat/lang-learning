let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
  pkgs = import nixpkgs { };

  # src's
  src = pkgs.fetchFromGitHub {
    owner = "cucapra";
    repo = "filament";
    rev = "bb771f1b470b31178b68d238844995de159b7f30";
    hash = "sha256-pHG0H4e6DieZSV+qiDHcmq1i4+CdqDJOfIAQnGmxba8=";
  };
  srcCalyx = pkgs.fetchFromGitHub {
    owner = "calyxir";
    repo = "calyx";
    rev = "v0.7.1";
    hash = "sha256-JZl+8JT/gngZ2Vunz7w3vP/iv3qxSw4jh8/C4SSHNd8=";
  };

  # Dependencies
  runt = pkgs.callPackage ./runt/package.nix { };
  calyx = pkgs.callPackage ./calyx/package.nix { inherit runt fud; src = srcCalyx; };
  fud = pkgs.callPackage ./calyx/fud/package.nix { src = "${srcCalyx.outPath}/fud"; };
in
pkgs.callPackage ./package.nix {
  inherit src runt calyx fud;
}
