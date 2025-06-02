library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
    generic (width : natural := 8);
    port (
        clk, reset_count, sck_rise : in std_logic;
        mincount, halfcount : out std_logic
    );
end entity counter;

architecture rtl of counter is
    signal count : unsigned(width-1 downto 0);
begin
    process(clk, reset_count) is
    begin
        if rising_edge(clk) then
            if reset_count then
                count <= (others => '0');
            elsif sck_rise then
                count <= (others => '0') when count = 15 else count + 1;
            end if;
        end if;
    end process;

    mincount <= '1' when count = 0 else '0';
    halfcount <= '1' when count = 8 else '0';
end architecture;