library work;
use work.seg7_pkg.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seg7ctrl is
    port
    (
        mclk : in std_logic; --100MHz, positive flank
        reset : in std_logic; --Asynchronous reset, active high
        velocity : in signed(7 downto 0);
        abcdefg : out std_logic_vector(6 downto 0);
        c : out std_logic
    );
end entity seg7ctrl;

architecture rtl of seg7ctrl is
    signal speed : unsigned(7 downto 0);
    signal d0, d1 : std_logic_vector(3 downto 0);
begin
    speed <= unsigned(abs(velocity));
    d1 <= std_logic_vector(speed(7 downto 4));
    d0 <= std_logic_vector(speed(3 downto 0));

    process(mclk, reset) is
        variable count : unsigned(19 downto 0);
    begin
        if reset then
            count := (others => '0');
            c <= '0';
        elsif rising_edge(mclk) then
            count := (others => '0') when (count = 999999) else count + 1;
            c <= not c when (count = 0) else c;
        end if;
    end process;

    abcdefg <= (others => '0') when reset else 
        bin2ssd(d1) when c else bin2ssd(d0);
end architecture;