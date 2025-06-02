library ieee;
use ieee.std_logic_1164.all;

entity shiftn is
    generic (n : integer := 64);
    port (
        -- System Clock and Reset
        rst_n       : in  std_logic;                        -- Reset
        mclk        : in  std_logic;                        -- Clock
        -- Shifted data in and out
        serial_in   : in  std_logic;                        -- serial input
        serial_out  : out std_logic;                        -- serial output
        b           : out std_logic_vector(n - 1 downto 0)  -- parallel output
    );
end shiftn;

architecture structural of shiftn is
    component dff is
        port(
            rst_n     : in  std_logic;
            mclk      : in  std_logic;
            din       : in  std_logic;
            dout      : out std_logic
        );
    end component;

    signal d : std_logic_vector(n downto 0);
begin
    d(n) <= serial_in;

    dff_loop: for i in n downto 1 generate 
        dffi: dff port map (
            rst_n => rst_n,
            mclk => mclk,
            din => d(i),
            dout => d(i - 1)
        );
    end generate dff_loop;

    b <= d(n - 1 downto 0);
    serial_out <= d(0);
end architecture;