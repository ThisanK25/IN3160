import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def test(dut):
    dut._log.info("Running test...")

    # Test every input value
    dut.inp.value = 0b11
    await Timer(10, units="ns")

    dut.inp.value = 0b10
    await Timer(10, units="ns")

    dut.inp.value = 0b01
    await Timer(10, units="ns")

    dut.inp.value = 0b00
    await Timer(10, units="ns")

    dut._log.info("Running test...done")