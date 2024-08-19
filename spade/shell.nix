{
  pkgs ? import <nixpkgs> { system = "x86_64-darwin"; },
}:
pkgs.mkShell

  {
    # nativeBuildInputs is usually what you want -- tools you need to run
    buildInputs = with pkgs; [
      libiconv # for building spade compiler

      python312
      python312Packages.cocotb
      verilog
      verilator
      yosys
      nextpnr
    ];

    # shellHook = ''
    # ruff check --fix test/ && swim test
    # '';
  }
