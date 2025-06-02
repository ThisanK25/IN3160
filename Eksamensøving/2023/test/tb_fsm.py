import cocotb
from cocotb.triggers import RisingEdge, FallingEdge, Edge, Timer, ClockCycles, ReadOnly
from cocotb.clock import Clock
from cocotb.utils import get_sim_time
from cocotb import start_soon

CLK_PERIOD_NS = 10

data = [0xAA, 0x0F, 0xF2, 0xFF, 0x02, 0x03]
state = {0: "idle", 1: "wait", 2: "valid"}

async def reset(dut):
    await FallingEdge(dut.clk)
    dut.rstn.value = 0
    dut.sdata.value = 0
    await RisingEdge(dut.clk)
    dut.rstn.value = 1

async def reset_check(dut):
    while True:
        await RisingEdge(dut.rstn)
        await ReadOnly()
        assert dut.tdata.value == 0, f"tdata={dut.tdata.value}. Register not reset."
        assert dut.tvalid.value == 0, f"tvalid={dut.tvalid.value}. Register not reset."

async def stimuli_generator(dut):
    for i in data:
        for j in bin(i).lstrip("0b").zfill(8):
            dut.sdata.value = int(j)
            await RisingEdge(dut.clk)

async def tdata_check(dut):
    while True:
        await RisingEdge(dut.clk)
        await ReadOnly()
        if state[int(dut.state.value)] == "valid":
            assert int(dut.tdata.value) != 0xFF, f"tdata={dut.tdata.value} in valid state"
        else:
            assert int(dut.tdata.value) == 0, f"tdata={dut.tdata.value} not in valid state"

async def tvalid_check(dut):
    while True:
        await RisingEdge(dut.tvalid)
        await ReadOnly()
        start = get_sim_time(units='ns')
        await FallingEdge(dut.tvalid)
        await ReadOnly()
        time = get_sim_time(units='ns') - start
        assert time == CLK_PERIOD_NS, f"tvalid is on for {time/CLK_PERIOD_NS} clock cycles"

async def compare(dut):
    await tdata_check(dut)  
    await tvalid_check(dut)

@cocotb.test()
async def main_test(dut):
    dut._log.info("Starting test...")
    start_soon(Clock(dut.clk, CLK_PERIOD_NS, units='ns').start())
    dut._log.info("Resetting values...")
    start_soon(reset_check(dut))
    await reset(dut)
    dut._log.info("Running tests...")
    start_soon(compare(dut))
    await stimuli_generator(dut)
    dut._log.info("Test complete!")
