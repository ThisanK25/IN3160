library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity compute_seq is
    port (
        clk : in std_logic;
        a, b, c, d : in std_logic_vector(15 downto 0);
        result : out std_logic_vector(17 downto 0)
    );
end entity compute_seq;

architecture rtl of compute_seq is
    signal u_a, u_b, u_c, u_d : unsigned(17 downto 0);
begin
    u_a <= unsigned("00" & a);
    u_b <= unsigned("00" & b);
    u_c <= unsigned("00" & c);
    u_d <= unsigned("00" & d);
    result <= std_logic_vector(u_a + u_b + u_c + u_d) when rising_edge(clk);
end architecture;