{
  # source code repo
  src,
  # dependencies
  # python3,
  python3Packages,
}:

python3Packages.buildPythonPackage {
  pname = "fud";
  version = "0.0.1";
  format = "flit";

  inherit src;

  build-system = with python3Packages; [
    flit
  ];
  buildInputs = [
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
    flit build --format wheel
  '';

  installCheckPhase = ''
    $out/bin/fud check
  '';

  meta = { };
}
