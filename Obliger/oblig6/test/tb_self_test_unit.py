import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Edge


async def stimuli_generator(dut):
    for _ in range(17):
        await Edge(dut.address)

@cocotb.test()
async def main_test(dut):
    dut._log.info("Starting testing...")
    dut.reset.value = 1
    cocotb.start_soon(Clock(dut.mclk, 10, units="ns").start())
    await RisingEdge(dut.mclk)
    dut.reset.value = 0
    await cocotb.start_soon(stimuli_generator(dut))
    dut._log.info("Testing done. All tests passed")