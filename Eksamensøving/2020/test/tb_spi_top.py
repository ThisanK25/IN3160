import cocotb
from cocotb import start_soon
from cocotb.triggers import Edge, RisingEdge, FallingEdge, First, ReadOnly, ClockCycles
from cocotb.clock import Clock
import numpy as np

data_in = [0x00, 0xFF, 0xAA, 0x73, 0x34, 0xC6]
random_indices = [4, 7, 10, 18, 27]

async def stimuli_generator(dut):
    for i in range(31):
        dut.mosi.value = int(np.round(np.random.rand()))
        dut.sck.value = int(np.round(np.random.rand()))
        if i in random_indices:
            dut.load.value = 1
            await RisingEdge(dut.clk)
            dut.load.value = 0
        if i%6 == 0:
            dut.data_in.value = data_in[i//6]
        await RisingEdge(dut.clk)

async def output_check(dut):
    while True:
        await RisingEdge(dut.mosi)
        await ReadOnly()
        mosi = dut.mosi.value
        await First(RisingEdge(dut.load), ClockCycles(dut.clk, 8))
        await ReadOnly()
        if dut.load.value == 1:
            assert dut.data_out.value == dut.data_in.value, f"{dut.data_out.value} != {dut.data_in.value}"
        else:
            assert dut.miso.value == mosi, f"{dut.miso.value} != {mosi}"
        print(dut.data_out.value)

@cocotb.test()
async def main_test(dut):
    dut._log.info("Starting test...")
    start_soon(Clock(dut.clk, 10, units='ns').start())
    dut.ss.value = 1
    await ClockCycles(dut.clk, 2)
    dut.ss.value = 0
    dut.data_in.value = 0
    dut.mosi.value = 0
    dut.sck.value = 0
    start_soon(output_check(dut))
    await stimuli_generator(dut)
