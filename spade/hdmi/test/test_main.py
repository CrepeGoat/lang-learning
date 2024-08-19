# top = main::main

from cocotb.clock import Clock
from spade import FallingEdge, SpadeExt
from cocotb import cocotb

@cocotb.test()
async def test_main(circuit):
    s = SpadeExt(circuit) # Wrap the circuit in the Spade wrapper

    # To access unmangled signals as cocotb values (without the spade wrapping) use
    # <signal_name>_i
    # For cocotb functions like the clock generator, we need a cocotb value
    clk = circuit.clk_i

    await cocotb.start(Clock(
        clk,
        period=10,
        units='ns'
    ).start())

    await FallingEdge(clk)

    s.o.assert_eq(0)
