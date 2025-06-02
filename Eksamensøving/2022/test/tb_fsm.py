import cocotb
from cocotb import start_soon
from cocotb.triggers import First, FallingEdge, RisingEdge, ClockCycles, ReadOnly
from cocotb.clock import Clock
from cocotb.utils import get_sim_time
import numpy as np

state = {0: "s_init", 1: "s_hold", 2: "s_count"}
CLK_PERIOD_NS = 10

async def reset(dut):
    await FallingEdge(dut.clk)
    dut.reset.value = 1
    dut.x.value = 0
    await RisingEdge(dut.clk)
    dut.reset.value = 0

async def reset_check(dut):
    while True:
        await FallingEdge(dut.reset)
        await ReadOnly()
        assert dut.z.value == 0, "Register not reset"

async def z_on_check(dut):
    while True:
        await RisingEdge(dut.x)
        if state[int(dut.state.value)] == "s_init":
            await ClockCycles(dut.clk, 1)
        await ReadOnly()
        assert dut.z.value == 1, "z not set after x"

async def z_duration_check(dut):
    while True:
        await FallingEdge(dut.x)
        await First(RisingEdge(dut.x), ClockCycles(dut.clk, int(dut.N.value)))
        await ReadOnly()
        if dut.x.value == 0:
            assert FallingEdge(dut.z), "z not on for N clock cycles after x is off"

async def stimuli_generator(dut):
    for _ in range(50):
        await FallingEdge(dut.clk)
        dut.x.value = int(np.round(np.random.rand(), 0))
        await RisingEdge(dut.clk)

@cocotb.test()
async def main_test(dut):
    dut._log.info("Starting test")
    start_soon(Clock(dut.clk, CLK_PERIOD_NS, units='ns').start())
    start_soon(reset_check(dut))
    await reset(dut)
    start_soon(z_on_check(dut))
    start_soon(z_duration_check(dut))
    await stimuli_generator(dut)
    dut._log.info("Test complete!")