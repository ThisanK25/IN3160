library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity output_synchronizer is
    port (
        mclk, reset, dir, en : in std_logic;
        dir_synch, en_synch : out std_logic
    );
end entity output_synchronizer;

architecture rtl of output_synchronizer is
begin
    process(mclk, reset) is
    begin
        if reset then
            dir_synch <= '0';
            en_synch <= '0';
        elsif rising_edge(mclk) then
            dir_synch <= dir;
            en_synch <= en;
        end if;
    end process;
end;