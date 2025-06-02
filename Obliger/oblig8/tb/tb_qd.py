import cocotb
from cocotb.triggers import Edge, RisingEdge, FallingEdge, Timer, ReadOnly
from cocotb.clock import Clock
from cocotb.utils import get_sim_time

CLOCK_PERIOD_NS = 10

sa = [0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0]
sb = [0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1]

state_conv_table = {
    0: 's_reset',
    1: 's_init',
    2: 's_0',
    3: 's_1',
    4: 's_2',
    5: 's_3'
}

async def pos_inc_check(dut):
    while True:
        await RisingEdge(dut.pos_inc)
        start = get_sim_time('ns')
        await FallingEdge(dut.pos_inc)
        time = get_sim_time('ns') - start
        assert time == CLOCK_PERIOD_NS, "pos_inc does not last 1 clock cycle"

async def pos_dec_check(dut):
    while True:
        await RisingEdge(dut.pos_dec)
        start = get_sim_time('ns')
        await FallingEdge(dut.pos_dec)
        time = get_sim_time('ns') - start
        assert time == CLOCK_PERIOD_NS, "pos_dec does not last 1 clock cycle"

async def err_check(dut):
    while True:
        await FallingEdge(dut.err)
        await ReadOnly()
        assert state_conv_table[int(dut.state.value)] == 's_reset', "State not set to s_reset after error"
        
async def state_change_checker(dut):
    while True:
        await Edge(dut.state)
        await ReadOnly()
        if state_conv_table[int(dut.state.value)] == 's_0':
            assert state_conv_table[int(dut.next_state.value)] != 's_2', "Illegal state change from s_0"
        elif state_conv_table[int(dut.state.value)] == 's_1':
            assert state_conv_table[int(dut.next_state.value)] != 's_3', "Illegal state change from s_1"
        elif state_conv_table[int(dut.state.value)] == 's_2':
            assert  state_conv_table[int(dut.next_state.value)] != 's_0', "Illegal state change from s_2"
        elif state_conv_table[int(dut.state.value)] == 's_3':
            assert state_conv_table[int(dut.next_state.value)] != 's_1', "Illegal state change from s_3"

async def stimuli_generator(dut):
    for a, b in zip(sa, sb):
        dut.sa.value = a
        dut.sb.value = b
        await Timer(30*CLOCK_PERIOD_NS, units='ns')

@cocotb.test()
async def main_test(dut):
    dut._log.info("Running test...")
    dut.reset.value = 1
    cocotb.start_soon(Clock(dut.mclk, CLOCK_PERIOD_NS, units='ns').start())
    dut.reset.value = 0
    cocotb.start_soon(pos_inc_check(dut))
    cocotb.start_soon(pos_dec_check(dut))
    cocotb.start_soon(err_check(dut))
    cocotb.start_soon(state_change_checker(dut))
    await cocotb.start_soon(stimuli_generator(dut))
    dut._log.info("Running test... complete")