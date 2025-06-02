library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity compute_pielined is
    generic (N : natural = 10);
    port (
        clk, reset : in std_logic;
        a, b, c : in std_logic_vector(N-1 downto 0);
        vdata : in std_logic;
        tdata : out std_logic_vector(2*N downto 0);
        tvalid : out std_logic
    );
end entity compute_pielined;

architecture rtl of compute_pipelined is
    signal vdata_pipelined: std_logic;
    signal r_c : std_logic_vector(N-1 downto 0);
    signal next_sum, r_sum : signed(N downto 0);
    signal next_tdata : signed(2*N downto 0);
begin
    process(clk) is
    begin
        if reset then
            tdata <= (others => '0');
            tvalid <= '0';

            vdata_pipelined <= '0';
            r_sum <= (others => '0');
            r_c <= '0';
        elsif rising_edge(clk) then
            tdata <= std_logic_vector(next_tdata);
            tvalid <= vdata_pipelined;
            
            vdata_pipelined <= vdata;
            r_sum <= next_sum;
            r_c <= c;
        end if;
    end process;

    process(all) is
    begin
        next_sum <= signed('0' & a) + signed('0' & b);
        next_tdata <= (others => '0') when not valid_pipelined else r_sum*signed(r_c);
    end process;
end architecture;