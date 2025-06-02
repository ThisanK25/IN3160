library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package subprog_pkg is
    function parity_toggle(indata1: std_logic_vector) return std_logic;

    function parity_xor(indata2: std_logic_vector) return std_logic;
end package subprog_pkg;

package body subprog_pkg is
    function parity_toggle(indata1: std_logic_vector) return std_logic is
        variable toggle : std_logic;
    begin
        toggle := '0';
        for i in indata1'range loop
            if indata1(i) = '1' then
                toggle := not toggle;
            end if;        
        end loop;
        return toggle;
    end;

    function parity_xor(indata2: std_logic_vector) return std_logic is
    begin
        return xor indata2;
    end;
end package body subprog_pkg;