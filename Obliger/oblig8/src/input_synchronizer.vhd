library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity input_synchronizer is
    port (
        mclk, reset, sa, sb : in std_logic;
        sa_synch, sb_synch : out std_logic
    );
end entity input_synchronizer;

architecture rtl of input_synchronizer is
    signal sa_q, sb_q : std_logic;
begin
    process(mclk, reset) is
    begin
        if reset then
            sa_q <= '0';
            sa_synch <= '0';
            sb_q <= '0';
            sb_synch <= '0';
        elsif rising_edge(mclk) then
            sa_q <= sa;
            sb_q <= sb;
            sa_synch <= sa_q;
            sb_synch <= sb_q;
        end if;
    end process;
end;