{
  # source code repo
  src,
  # dependencies
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "calyx-py";
  version = "";

  inherit src;

  build-system = with python3Packages; [
    flit
  ];

  buildPhase = ''
    flit build --format wheel
  '';

  meta = { };
}
