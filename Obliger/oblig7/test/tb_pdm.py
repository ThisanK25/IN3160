import random
import cocotb
from cocotb.triggers import RisingEdge, FallingEdge, Timer
from cocotb.clock import Clock
from cocotb.utils import get_sim_time
CLOCK_PERIOD_NS = 10
req_set=[4,17,27,39,45]

async def initialize(dut):
    dut.reset.value = 1
    await RisingEdge(dut.clk)
    dut.reset.value = 0
    dut.min_on.value = 5
    dut.min_off.value = 10
    dut.max_on.value = 200

async def stimuli_generator(dut):
    for i in range(50):
        dut.setpoint.value = random.randint(0, 2**dut.WIDTH.value - 1)
        await Timer(3*CLOCK_PERIOD_NS, units='ns')
        if i in req_set:
            await FallingEdge(dut.pdm_pulse)
            dut.mea_req.value = 1
            await RisingEdge(dut.mea_ack)
            await Timer(5*CLOCK_PERIOD_NS, units='ns')
            dut.mea_req.value = 0
        await Timer(50*CLOCK_PERIOD_NS, units='ns')

async def max_on_check(dut):
    while True:
        await FallingEdge(dut.pdm_pulse)
        start = get_sim_time('ns')
        await RisingEdge(dut.pdm_pulse)
        end = get_sim_time('ns')
        duration = end - start
        cycles = duration/CLOCK_PERIOD_NS
        assert cycles <= int(dut.max_on.value) + 1, (
            f"""Pulse of {cycles} cycles greater than
            max_on: {int(dut.max_on.value)}""")

async def min_on_check(dut):
    while True:
        await FallingEdge(dut.pdm_pulse)
        start = get_sim_time('ns')
        await RisingEdge(dut.pdm_pulse)
        end = get_sim_time('ns')
        duration = end - start
        cycles = duration/CLOCK_PERIOD_NS
        assert cycles >= int(dut.min_on.value), (
            f"""Pulse of {cycles} cycles shorter than
            min_on: {int(dut.min_on.value)}""")

async def mea_ack_low(dut):
    while dut.pdm_pulse.value == 1:
        assert dut.mea_ack.value == 0, (
            """Acknowledge flag asserted when pulse is high""")

async def mea_req_assert(dut):
    while True:
        await RisingEdge(dut.mea_req)
        start = get_sim_time('ns')
        await RisingEdge(dut.mea_ack)
        end = get_sim_time('ns')
        duration = end - start
        assert duration <= 2*CLOCK_PERIOD_NS, (
            f"""Acknowledge signal asserted within {duration/CLOCK_PERIOD_NS} clock cycles""")

async def mea_req_deassert(dut):
    while True:
        await FallingEdge(dut.mea_req)
        start = get_sim_time('ns')
        await FallingEdge(dut.mea_ack)
        end = get_sim_time('ns')
        duration = end - start
        assert duration <= 2*CLOCK_PERIOD_NS, (
            f"""Acknowledge signal deasserted within {duration/CLOCK_PERIOD_NS} clock cycles""")

async def duty_cycle(dut):
    while True:
        await FallingEdge(dut.pdm_pulse)
        start = get_sim_time('ns')
        await FallingEdge(dut.pdm_pulse)
        end = get_sim_time('ns')
        pulse_time = end - start
        assert pulse_time/CLOCK_PERIOD_NS <= 0.1*(dut.setpoint.value), (
            """Duty cycle greater than 10%""")

@cocotb.test()
async def main_test(dut):
    dut._log.info("Running test...")
    cocotb.start_soon(Clock(dut.clk, CLOCK_PERIOD_NS, units='ns').start())
    cocotb.start_soon(initialize(dut))
    cocotb.start_soon(max_on_check(dut))
    cocotb.start_soon(min_on_check(dut))
    cocotb.start_soon(mea_ack_low(dut))
    cocotb.start_soon(mea_req_assert(dut))
    cocotb.start_soon(mea_req_deassert(dut))
    cocotb.start_soon(duty_cycle(dut))
    await cocotb.start_soon(stimuli_generator(dut))
    dut._log.info("Running test... complete")
