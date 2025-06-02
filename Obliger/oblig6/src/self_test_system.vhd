library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity self_test_system is
    port (
        reset : in std_logic;
        mclk : in std_logic;
        abcdefg : out std_logic_vector(6 downto 0);
        c : out std_logic
    );
end entity;

architecture structural of self_test_system is
    signal d0, d1 : std_logic_vector(3 downto 0);
begin
    STU: entity work.self_test_unit(self_test)
    port map (
        reset => reset,
        mclk => mclk,
        d0 => d0,
        d1 => d1
    );

    SEG7: entity work.seg7ctrl(alt_seg7)
    port map (
        reset => reset,
        mclk => mclk,
        d0 => d0,
        d1 => d1,
        abcdefg => abcdefg,
        c => c
    );
end architecture;