library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity self_test_unit is
    port (
        reset : in std_logic;
        mclk : in std_logic;
        d0, d1: out std_logic_vector(3 downto 0)
    );
end entity self_test_unit;

architecture self_test of self_test_unit is
    signal address: std_logic_vector(3 downto 0);
    signal data : std_logic_vector(7 downto 0);
begin
    ROM: entity work.ROM(rom_arch)
    port map (
        address => address,
        data => data
    );
        
    process(mclk, reset) is
        variable count : unsigned(26 downto 0);
        variable second_tick : std_logic;
    begin
        if reset then
            count := (others => '0');
            second_tick := '0';
            address <= (others => '0');
        elsif rising_edge(mclk) then
            count := (others => '0') when (count = 99999999) else count + 1;
            second_tick := '1' when (count = 0) else '0';
            address <= std_logic_vector(unsigned(address) + 1) when second_tick;
        end if;
    end process;

    d0 <= (others=> '0') when reset else data(3 downto 0);
    d1 <= (others=> '0') when reset else data(7 downto 4);
end architecture;