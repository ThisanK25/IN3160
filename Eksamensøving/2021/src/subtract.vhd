library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity subtract is
    generic (size : integer = 16);
    port (
        a, b : in std_logic_vector(size-1 downto 0);
        result : out std_logic_vector(size downto 0)
    );
end entity subtract;

architecture dataflow of subtract is
    signal i_result : signed(size downto 0);
begin
    i_result <= (signed('0' & a) - signed('0' & b));
    result <= std_logic_vector(i_result);
end architecture;