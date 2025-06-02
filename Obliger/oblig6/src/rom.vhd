library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity rom is
    port(
        address: in std_logic_vector(3 downto 0);
        data: out std_logic_vector(7 downto 0)
    );
end entity;

architecture rom_arch of rom is
    type memory_array is array(0 to 15) of
        std_logic_vector(7 downto 0);
    
    constant ROM_DATA: memory_array := (
        "00010010",
        "00110100",
        "01000000",
        "00000000",
        "01010110",
        "01110011",
        "00000000",
        "10000110",
        "10010000",
        "00000000",
        "10101011",
        "00110000",
        "00000000",
        "11000110",
        "01100101",
        "00000000"
    );
begin
    data <= ROM_DATA(to_integer(unsigned(address)));
end;