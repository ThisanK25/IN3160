library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity edge_detector is
    port (
        clk, ss, sck : in std_logic;
        sck_rise : out std_logic
    );
end entity edge_detector;

architecture rtl of edge_detector is
    type state_type is (s_0, s_1);
    signal state, next_state : state_type := s_0;
begin
    state <= next_state when rising_edge(clk);
    next_state <= s_1 when sck else s_0;
    sck_rise <= '1' when (sck = '1' and state = s_0) else '0';
end architecture;