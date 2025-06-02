library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture BEHAVIORAL of DECODER is
begin
    -- select statement
    with inp select outp <=
        "1110" when "00",
        "1101" when "01",
        "1011" when "10",
        "0111" when "11",
        "0000" when others;
end architecture;