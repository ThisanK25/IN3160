library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shifter is
    generic (width : natural := 8);
    port (
        clk, ss, sck_rise, mosi, load : in std_logic;
        data_in : in std_logic_vector(width-1 downto 0);
        data_out : out std_logic_vector(width-1 downto 0);
        miso : out std_logic
    );
end entity shifter;

architecture rtl of shifter is
begin
    process(clk) is
    begin
        if rising_edge(clk) then
            if ss then
                data_out <= (others => '0');
            else
                data_out <= data_in when load else 
                mosi & data_out(width-1 downto 1) when rising_edge(sck_rise);
            end if;
        end if;
    end process;

    miso <= data_out(0);
end architecture;