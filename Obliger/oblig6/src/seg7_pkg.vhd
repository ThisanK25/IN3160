library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package seg7_pkg is
    function bin2ssd(inp: std_logic_vector(3 downto 0)) return std_logic_vector;

    function alt_bin2ssd(inp: std_logic_vector(3 downto 0)) return std_logic_vector;
end package seg7_pkg;

package body seg7_pkg is
    function bin2ssd(inp: std_logic_vector(3 downto 0)) return std_logic_vector is
        variable outp : std_logic_vector(6 downto 0);
    begin
        case inp is
            when "0000" => outp := "1111110";
            when "0001" => outp := "0110000";
            when "0010" => outp := "1101101";
            when "0011" => outp := "1111001";
            when "0100" => outp := "0110011";
            when "0101" => outp := "1011011";
            when "0110" => outp := "1011111";
            when "0111" => outp := "1110000";
            when "1000" => outp := "1111111";
            when "1001" => outp := "1111011";
            when "1010" => outp := "1110111";
            when "1011" => outp := "0011111";
            when "1100" => outp := "1001110";
            when "1101" => outp := "0111101";
            when "1110" => outp := "1001111";
            when "1111" => outp := "1000111";
            when others => outp := "0000000";
        end case;
        return outp;
    end;

    function alt_bin2ssd(inp: std_logic_vector(3 downto 0)) return std_logic_vector is
        variable outp : std_logic_vector(6 downto 0);
    begin
        case inp is
            when "0000" => outp := "0000000";
            when "0001" => outp := "0011110";
            when "0010" => outp := "0111100";
            when "0011" => outp := "1001111";
            when "0100" => outp := "0001110";
            when "0101" => outp := "0111101";
            when "0110" => outp := "0011101";
            when "0111" => outp := "0010101";
            when "1000" => outp := "0111011";
            when "1001" => outp := "0111110";
            when "1010" => outp := "1110111";
            when "1011" => outp := "0000101";
            when "1100" => outp := "1111011";
            when "1101" => outp := "0011100";
            when "1110" => outp := "0001101";
            when "1111" => outp := "1111111";
            when others => outp := "0000000";
        end case;
        return outp;
    end;
end package body seg7_pkg;