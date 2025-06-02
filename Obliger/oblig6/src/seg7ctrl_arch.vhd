library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.seg7_pkg.all;

architecture alt_seg7 of seg7ctrl is
begin
    CONTROL: process(mclk, reset) is
        variable count : unsigned(19 downto 0);
    begin
        if reset then
            count := (others => '0');
            c <= '0';
        elsif rising_edge(mclk) then
            count := (others => '0') when (count = 9999999) else count + 1;
            c <= not c when (count = 0) else c;
        end if;
    end process CONTROL;

    abcdefg <= (others => '0') when reset else
        alt_bin2ssd(d1) when c else alt_bin2ssd(d0);
end architecture;