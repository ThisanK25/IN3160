library ieee;
use ieee.std_logic_1164.all;

entity spi_top is
    generic(WIDTH : natural := 8);
    port (
        clk : in std_logic;
        SS : in std_logic;
        SCK : in std_logic;
        MOSI : in std_logic;
        MISO : out std_logic;
        data_in : in std_logic_vector(WIDTH-1 downto 0);
        data_out : out std_logic_vector(WIDTH-1 downto 0);
        valid : out std_logic
    );
end entity spi_top;

architecture structural of spi_top is
-- insert structural description here
    signal sck_rise : std_logic;
    signal load : std_logic;
    signal reset_count : std_logic;
    signal mincount : std_logic;
    signal halfcount : std_logic;
begin
    EDGE: entity work.edge_detector
    port map (
        clk => clk,
        ss => ss,
        sck => sck,
        sck_rise => sck_rise
    );

    SHIFTER: entity work.shifter
    port map (
        clk => clk,
        ss => ss,
        sck_rise => sck_rise,
        mosi => mosi,
        load => load,
        data_in => data_in,
        data_out => data_out,
        miso => miso
    );

    COUNTER: entity work.counter
    port map (
        clk => clk,
        reset_count => reset_count,
        sck_rise => sck_rise,
        mincount => mincount,
        halfcount => halfcount
    );

    FSM: entity work.fsm
    port map (
        clk => clk,
        ss => ss,
        halfcount => halfcount,
        mincount => mincount,
        data => data_out,
        load => load,
        valid => valid,
        reset_count => reset_count
    );
end architecture structural;