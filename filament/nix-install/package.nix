{
  # nix stdlib
  lib,
  rustPlatform,
  fetchFromGitHub,
  # dependencies
  python3,
  python3Packages,
  runt,
  jq,
  z3,
  cvc5,
  whichSmt ? "z3",
}:
if (whichSmt != "z3" && whichSmt != "cvc5") then
  throw "invalid value for `whichSmt`; must be either `z3` or `cvc5`"
else
  rustPlatform.buildRustPackage {
    pname = "filament";
    version = "0.1.0";

    src = fetchFromGitHub {
      owner = "cucapra";
      repo = "filament";
      rev = "bb771f1b470b31178b68d238844995de159b7f30";
      hash = "sha256-pHG0H4e6DieZSV+qiDHcmq1i4+CdqDJOfIAQnGmxba8=";
    };

    cargoPatches = [ ./add-Cargo.lock.patch ];
    cargoHash = "sha256-VMsjEP4/ivVe2UrXuZvMuiEhIr8RruHOX/e2kL0CJgU=";

    nativeBuildInputs = [
      python3
      python3Packages.numpy
      runt
      jq
    ] ++ (if (whichSmt == "z3") then [ z3 ] else [ cvc5 ]);

    patches = [ ./runt.toml.patch ];
    doCheck = false;
    doInstallCheck = true;
    installCheckPhase = ''
      ln -s $out ./result
      runt -d
      rm ./result
    '';

    meta = with lib; {
      description = "Fearless hardware design";
      homepage = "https://filamenthdl.com";
      license = licenses.mit;
      platforms = platforms.all;
    };
  }
