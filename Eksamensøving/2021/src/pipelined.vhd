library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pipelined is
    port (
        clk, rst : in std_logic;
        a, b, c : in std_logic_vector(7 downto 0);
        result : out std_logic_vector(9 downto 0);
        start : in std_logic;
        result_valid : out std_logic
    );
end entity pipelined;

architecture rtl of pipelined is
    signal r_c : std_logic_vector(7 downto 0);
    signal next_ab, r_ab : unsigned(8 downto 0);
    signal next_result : unsigned(9 downto 0);
    signal valid_pipelined : std_logic;
begin
    process(clk, rst) is
    begin
        if rising_edge(clk) then
            result <= (others => '0') when rst else next_result;
            result_valid <= '0' when rst else valid_pipelined;

            r_ab <= (others => '0') when rst else next_ab;
            r_c <= (others => '0') when rst else c;
            valid_pipelined <= '0' when rst else start;
        end if;
    end process;

    next_ab <= unsigned('0' & a) + unsigned('0' & b);
    next_result <= ('0' & next_ab) + unsigned(r_c);
end architecture;