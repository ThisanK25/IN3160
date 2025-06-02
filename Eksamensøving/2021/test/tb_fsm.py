import cocotb
from cocotb.triggers import Edge, RisingEdge, FallingEdge, First, ReadOnly
from cocotb.clock import Clock
from cocotb import start_soon

data = [0xAA, 0x0F, 0xAA, 0x4A, 0x00, 0xAA, 0x6C]
CLK_PERIOD_NS = 10

async def reset(dut):
    dut.reset.value = 1
    dut.sdata.value = 0
    await RisingEdge(dut.clk)
    dut.reset.value = 0

async def reset_check(dut):
    while True:
        await FallingEdge(dut.reset)
        await ReadOnly()
        assert dut.dout.value == 0, f"dout={dut.dout.value}. Register not reset."
        assert dut.dvalid.value == 0, f"dvalid={dut.dvalid.value}. Register not reset."

async def stimuli_generator(dut):
    for i in data:
        for j in bin(i).lstrip("0b").zfill(8):
            await FallingEdge(dut.clk)
            dut.sdata.value = int(j)
            await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

async def dout_check(dut):
    while True:
        await First(Edge(dut.dout), RisingEdge(dut.dvalid))
        await ReadOnly()
        if int(dut.dout.value) != 0:
            assert dut.dout.value == dut.shiftreg.value, f"dout = {dut.dout.value} != {dut.shiftreg.value}"
        else:
            assert dut.dout.value == 0, "Output not reset after valid deassertion"

async def dvalid_check(dut):
    while True:
        await First(Edge(dut.dout), RisingEdge(dut.dvalid))
        await ReadOnly()
        if int(dut.dout.value) != 0:
            assert dut.dvalid.value == 1, "valid not set"

@cocotb.test()
async def main_test(dut):
    dut._log.info("Running test...")
    start_soon(Clock(dut.clk, CLK_PERIOD_NS, units='ns').start())
    start_soon(reset_check(dut))
    await reset(dut)
    dut._log.info("Starting compare")
    start_soon(dout_check(dut))
    start_soon(dvalid_check(dut))
    await stimuli_generator(dut)
    dut._log.info("Test complete!")
