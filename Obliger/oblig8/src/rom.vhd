library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all;

entity rom is
    generic (
        data_width : natural := 8;
        addr_width : natural := 5;
        addr_count : natural := 21;
        filename : string := "ROM_data_bits.txt"
    );
    port (
        address : in unsigned(addr_width-1 downto 0);
        data : out std_logic_vector(data_width-1 downto 0)
    );
end entity;

architecture dataflow of rom is
    type memory_array is array(0 to addr_count-1) of
        std_logic_vector(data_width-1 downto 0);
    
    impure function initialize_ROM(file_name: string)
        return memory_array is
        file init_file: text open read_mode is file_name;
        variable current_line: line;
        variable result: memory_array;
    begin
        for i in result'range loop
            readline(init_file, current_line);
            read(current_line, result(i));
        end loop;
        return result;
    end function;
    
    --initialize rom:
    constant ROM_DATA: memory_array := initialize_ROM(filename);
begin
    data <= ROM_DATA(to_integer(address));
end;