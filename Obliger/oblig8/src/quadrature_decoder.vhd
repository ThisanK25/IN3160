library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity quadrature_decoder is
    port (
        mclk, reset, sa, sb : in std_logic;
        pos_inc, pos_dec : out std_logic
    );
end entity quadrature_decoder;

architecture rtl of quadrature_decoder is
    type state_type is (
        s_reset,
        s_init,
        s_0,
        s_1,
        s_2,
        s_3
    );

    signal state, next_state : state_type;

    signal err : std_logic;
begin
    state <= s_reset when reset else next_state when rising_edge(mclk);

    NEXT_STATE_CL: process(all) is
    begin
        case state is
            when s_reset =>
                next_state <= s_init;
            when s_init =>
                next_state <= s_0 when (not sa and not sb) else
                    s_1 when (not sa and sb) else
                    s_3 when (sa and not sb) else
                    s_2 when (sa and sb);
            when s_0 =>
                next_state <= s_0 when (not sa and not sb) else
                    s_1 when (not sa and sb) else
                    s_3 when (sa and not sb) else
                    s_reset when (sa and sb);
            when s_1 =>
                next_state <= s_0 when (not sa and not sb) else
                    s_1 when (not sa and sb) else
                    s_reset when (sa and not sb) else
                    s_2 when (sa and sb);
            when s_2 =>
                next_state <= s_reset when (not sa and not sb) else
                    s_1 when (not sa and sb) else
                    s_3 when (sa and not sb) else
                    s_2 when (sa and sb);
            when s_3 =>
                next_state <= s_0 when (not sa and not sb) else
                    s_reset when (not sa and sb) else
                    s_3 when (sa and not sb) else
                    s_2 when (sa and sb);
        end case;
    end process NEXT_STATE_CL;

    OUTPUT_CL: process(all) is
    begin
        pos_inc <= '0';
        pos_dec <= '0';
        err <= '1' when next_state = s_reset else '0';
        case state is
            when s_0 =>
                pos_inc <= '1' when next_state = s_1;
                pos_dec <= '1' when next_state = s_3;
            when s_1 =>
                pos_inc <= '1' when next_state = s_2;
                pos_dec <= '1' when next_state = s_0;
            when s_2 =>
                pos_inc <= '1' when next_state = s_3;
                pos_dec <= '1' when next_state = s_1;
            when s_3 =>
                pos_inc <= '1' when next_state = s_0;
                pos_dec <= '1' when next_state = s_2;
            when others =>
                null;
        end case;
    end process OUTPUT_CL;
end architecture;