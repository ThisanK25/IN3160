library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture process_arch of subtract is
begin
    process(all) is
        variable i_result : signed(size downto 0);
    begin
        i_result := (signed('0' & a) - signed('0' & b));
        result <= std_logic_vector(i_result);
    end process;
end architecture;