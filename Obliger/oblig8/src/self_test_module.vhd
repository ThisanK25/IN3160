library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity self_test_module is
    port (
        mclk, reset : in std_logic;
        duty_cycle : out std_logic_vector(7 downto 0)
    );
end entity self_test_module;

architecture rtl of self_test_module is
    constant addr_count : natural := 21;
    constant addr_width : natural := 5;
    constant data_width : natural := 8;

    signal address : unsigned(addr_width-1 downto 0);
begin
    ROM: entity work.rom
    generic map (
        data_width => data_width,
        addr_width => addr_width,
        addr_count => addr_count,
        filename => "ROM_data_bits.txt"
    )
    port map (
        address => address,
        data => duty_cycle
    );

    process(mclk, reset) is
        variable counter : unsigned(28 downto 0);
    begin
        if reset then
            address <= (others => '0');
            counter := (others => '0');
        elsif rising_edge(mclk) then
            counter := (others => '0') when counter = 299999999 else counter + 1;
            address <= address + 1 when counter = 0 and address < addr_count - 1;
        end if;
    end process;
end architecture;