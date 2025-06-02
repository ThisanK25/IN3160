library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fsm is
    port (
        clk, reset, sdata : in std_logic;
        dout : out std_logic_vector(7 downto 0);
        dvalid : out std_logic
    );
end entity fsm;

architecture rtl of fsm is
    type state_type is (s_idle, s_wait, s_valid);
    signal state, next_state : state_type;

    signal shiftreg, next_shiftreg: std_logic_vector(7 downto 0) := (others => '0');
    signal count, next_count : unsigned(2 downto 0) := (others => '0');
begin
    CLK_REGISTER: process(clk, reset) is
    begin
        if rising_edge(clk) then
            state <= s_idle when reset else next_state;
            shiftreg <= (others => '0') when reset else next_shiftreg;
            count <= (others => '0') when reset else next_count;
        end if;
    end process CLK_REGISTER;

    NEXT_STATE_CL: process(all) is
    begin
        case state is
            when s_idle =>
                next_state <= s_wait when shiftreg = x"AA" else s_idle;
            when s_wait =>
                next_state <= s_valid when count = 6 else s_wait;
            when s_valid =>
                next_state <= s_idle;
        end case;
    end process NEXT_STATE_CL;

    OUTPUT_CL: process(all) is
    begin
        dvalid <= '0';
        dout <= (others => '0');
        next_count <= (others => '0');
        next_shiftreg <= shiftreg(6 downto 0) & sdata;
        case state is
            when s_idle =>
                null;
            when s_wait =>
                next_count <= count + 1;
            when s_valid =>
                dvalid <= '1';
                dout <= shiftreg;
        end case;
    end process OUTPUT_CL;
end architecture;