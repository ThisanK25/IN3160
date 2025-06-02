library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pdm is
    generic (WIDTH: natural := 16);
    port (
        clk,
        reset : in std_logic;
        setpoint,
        min_off,
        min_on,
        max_on : in std_logic_vector(WIDTH-1 downto 0);
        mea_req : in std_logic;
        mea_ack,
        pdm_pulse : out std_logic := '0'
    );
end entity pdm;

architecture rtl of pdm is
    type state_type is (S_PDM_0, S_PDM_1, S_MEA);
    signal state, next_state : state_type;

    signal timer : unsigned(WIDTH-1 downto 0) := (others => '0');
    signal count : unsigned(WIDTH-1 downto 0) := (others => '0');
    signal next_timer, next_count : unsigned(WIDTH-1 downto 0) := (others => '0'); 

    signal r_acc, next_acc : unsigned(WIDTH downto 0) := (others => '0');
    alias PDM_out : std_logic is r_acc(r_acc'left);
begin
    next_acc <= ('0' & unsigned(setpoint)) + ('0' & r_acc(WIDTH-1 downto 0));

    CLOCK: process(clk, reset) is
    begin
        if rising_edge(clk) then
            state <= S_PDM_0 when reset else next_state;
            r_acc <= next_acc;
            timer <= next_timer;
            count <= next_count;
        end if;
    end process CLOCK;
    
    NEXT_STATE_CL: process(all) is
    begin
        case state is
            when S_PDM_0 =>
                next_state <= S_MEA when mea_req else 
                    S_PDM_1 when (timer = 0 and count >= unsigned(min_on)) else S_PDM_0;
            when S_PDM_1 =>
                next_state <= S_PDM_0 when (timer = 0 or count = 0) else S_PDM_1;
            when S_MEA =>
                next_state <= S_PDM_0 when not mea_req else S_MEA;
        end case;
    end process NEXT_STATE_CL;
            
    OUTPUT_CL: process(all) is
    begin
        next_timer <= (others => '0') when timer = 0 else timer - 1;
        pdm_pulse <= '0';
        mea_ack <= '0'; 
        case state is
            when S_PDM_0 =>
                next_timer <= unsigned(max_on) when (timer = 0 and count >= unsigned(min_on));
                next_count <= count + 1 when (PDM_out = '1' and (count < 2**WIDTH - 1)) else count;
                pdm_pulse <= '0';
                mea_ack <= '0';
            when S_PDM_1 =>
                next_timer <= unsigned(min_off) when (timer = 0 or count = 0);
                next_count <= count - 1 when (PDM_out = '0' and (count > 0)) else count;
                pdm_pulse <= '1';
                mea_ack <= '0';
            when S_MEA =>
                mea_ack <= '1';
        end case;
    end process OUTPUT_CL;
end architecture;