import cocotb
from cocotb.triggers import Timer, RisingEdge
from cocotb.clock import Clock

@cocotb.test()
async def test(dut):
    dut._log.info("Running test...")

    dut.rst_n.value = 0b1
    dut.serial_in.value = 0b0

    cocotb.start_soon(Clock(dut.mclk, 100, units="ns").start())

    # Iterate by the amount of D-flipflops
    for i in range(32):
        # Start high
        await RisingEdge(dut.mclk)
        dut.serial_in.value = 0b1

        await RisingEdge(dut.mclk)
        dut.serial_in.value = 0b0

        # Reset in 16th iteration
        if i == 15:
            dut.rst_n.value = 0
            await RisingEdge(dut.mclk)
            dut.rst_n.value = 1

    dut._log.info("Running test... complete")
    await Timer(200, units="ns")