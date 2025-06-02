import cocotb
from cocotb.triggers import Timer, RisingEdge, Edge
from cocotb.clock import Clock

@cocotb.test()
async def test(dut):
    dut._log.info("Running test...")

    dut.rst_n.value = 0b1
    dut.serial_in.value = 0b0

    cocotb.start_soon(Clock(dut.mclk, 100, units="ns").start())

    # Iterate by the amount of D-flipflops
    for _ in range(dut.n.value):
        # Start low
        await RisingEdge(dut.mclk)
        dut.serial_in.value = 0b0

        await RisingEdge(dut.mclk)
        dut.serial_in.value = 0b1

    dut._log.info("Running test... complete")
    await Timer(200, units="ns")