library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fsm is
    generic (N : integer := 2);
    port (
        clk, reset, x : in std_logic;
        z : out std_logic
    );
end entity fsm;

architecture rtl of fsm is
    type state_type is (s_init, s_hold, s_count);
    signal state, next_state : state_type;

    signal r_count, next_count : unsigned(7 downto 0);
begin
    CLK_ASSIGNMENT: process(clk, reset) is
    begin
        if rising_edge(clk) then
            if reset then
                state <= s_init;
                r_count <= (others => '0');
            else
                state <= next_state;
                r_count <= next_count;
            end if;
        end if;
    end process CLK_ASSIGNMENT;

    NEXT_STATE_CL: process(all) is
    begin
        case state is
            when s_init =>
                next_state <= s_hold when x else s_init;
            when s_hold =>
                next_state <= s_hold when x else s_count;
            when s_count =>
                next_state <= s_count when r_count < N - 2 else
                    s_hold when x else s_init;
        end case;
    end process NEXT_STATE_CL;

    OUTPUT_CL: process(all) is
    begin
        z <= '0';
        next_count <= (others => '0');
        case state is
            when s_init =>
                null;
            when s_hold =>
                z <= '1';
            when s_count =>
                z <= '1';
                next_count <= r_count + 1 when (r_count < N - 2);
        end case;
    end process OUTPUT_CL;
end architecture;
