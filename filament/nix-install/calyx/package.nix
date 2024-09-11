{
  # nix stdlib
  lib,
  rustPlatform,
  fetchFromGitHub,
  python3Packages,
  symlinkJoin,
  # dependencies
  runt,
}:
let
  src = fetchFromGitHub {
    owner = "calyxir";
    repo = "calyx";
    rev = "v0.7.1";
    hash = "sha256-JZl+8JT/gngZ2Vunz7w3vP/iv3qxSw4jh8/C4SSHNd8=";
  };

  calyx-compiler = rustPlatform.buildRustPackage {
    pname = "calyx";
    version = "0.7.1";

    inherit src;
    cargoPatches = [
      ./Cargo.lock.patch
      ./cider-dap_Cargo.toml.patch
    ];
    cargoHash = "sha256-mMGkpUeWKqc2Srbtd1+3SYQjVCVRUU3VITfQohQDnfM=";

    nativeBuildInputs = [ runt ];

    patches = [ ./runt.toml.patch ];
    doCheck = false;
    doInstallCheck = false;

    meta = with lib; {
      description = "A Compiler Infrastructure for Accelerator Generators";
      homepage = "https://calyxir.org";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  calyx-py = python3Packages.buildPythonPackage {
    pname = "calyx-ast";
    version = "0.1.0";
    format = "flit";

    src = "${src.outPath}/calyx-py";

    build-system = with python3Packages; [
      flit
    ];

    buildPhase = ''
      flit build --format wheel
    '';
    doCheck = false;
    doInstallCheck = false;

    meta = { };
  };

  fud = python3Packages.buildPythonPackage {
    pname = "fud";
    version = "0.0.1";
    format = "flit";

    src = "${src.outPath}/fud";

    build-system = with python3Packages; [
      flit
    ];
    buildInputs = [
      # from calyx
      src
      # from pyproject.toml
      python3Packages.pybind11
      python3Packages.appdirs
      python3Packages.toml
      python3Packages.halo
      python3Packages.termcolor
      python3Packages.packaging
      python3Packages.numpy
      python3Packages.simplejson
      python3Packages.networkx
    ];

    buildPhase = ''
      export HOME=$(pwd)
      flit build --format wheel
    '';
    doCheck = false;
    doInstallCheck = false;

    meta = { };
  };

in
symlinkJoin {
  name = "calyx";
  paths = [
    calyx-compiler
    calyx-py
    fud
  ];

  nativeBuildInputs = [
    runt
  ];

  fixupPhase = ''
    $out/bin/fud config --create global.root ${src}
    $out/bin/fud config stages.calyx.exec ${calyx-compiler}/bin/calyx
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/fud check
    runt ${src} -d
  '';
}
