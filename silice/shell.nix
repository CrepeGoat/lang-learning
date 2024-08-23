{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell

  {
    # nativeBuildInputs is usually what you want -- tools you need to run
    buildInputs = with pkgs; [
      # as mentioned in the getting started on macOS instructions
      python312
      termcolor

      # the main program
      silice

      verilator
      # for running verilator
      libGL
      glfw

      verilog
      verilator
      yosys
      nextpnr
      gtkwave # for visualizing waveforms (see GetStarted.md)
    ];
  }
