import cocotb
from cocotb.triggers import Edge, RisingEdge, FallingEdge
from cocotb.clock import Clock

async def stimuli_generator(dut):
    for _ in range(20):
        await Edge(dut.duty_cycle)
    await RisingEdge(dut.mclk)

@cocotb.test()
async def main_test(dut):
    dut._log.info("Running test...")
    cocotb.start_soon(Clock(dut.mclk, 10, units='ns').start())
    dut.reset.value = 1
    await RisingEdge(dut.mclk)
    dut.reset.value = 0
    await cocotb.start_soon(stimuli_generator(dut))
    dut._log.info("Running test... complete")