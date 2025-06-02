library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DECODER is
    port
        (
            inp     : in  std_logic_vector(1 downto 0);
            outp    : out std_logic_vector(3 downto 0)
            );
end DECODER;