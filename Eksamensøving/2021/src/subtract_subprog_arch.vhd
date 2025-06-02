library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture subprog_arch of subtract is
    function subtract_func(a, b: std_logic_vector(size-1 downto 0)) 
        return signed is
        variable i_result : signed(size downto 0);
    begin
        i_result := (signed('0' & a) - signed('0' & b));
        return i_result;
    end function;
begin
    result <= std_logic_vector(subtract_func(a, b));
end architecture;