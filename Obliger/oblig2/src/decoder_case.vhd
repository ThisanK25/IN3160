library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture BEHAVIORAL of DECODER is
begin
    process (all)
    begin
        -- case statement
        case inp is
            when "00" => outp <= "1110";
            when "01" => outp <= "1101";
            when "10" => outp <= "1011";
            when "11" => outp <= "0111";
            when others => outp <= "0000";
        end case;
    end process;
end architecture;