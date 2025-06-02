library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pulse_width_modulator is
    port (
        mclk, reset : in std_logic;
        duty_cycle : in std_logic_vector(7 downto 0);
        dir, en : out std_logic
    );
end entity pulse_width_modulator;

architecture rtl of pulse_width_modulator is
    type state_type is (reverse_idle, forward_idle, forward, reverse);
    signal state, next_state : state_type;

    signal pwm : std_logic;
    signal absolute : unsigned(7 downto 0);
begin
    absolute <= unsigned(abs(signed(duty_cycle)));
    
    CLK_REGISTER: process(mclk, reset) is
        variable count : unsigned(13 downto 0) := (others => '0');
    begin
        if reset then
            state <= reverse_idle;
            count := (others => '0');
            pwm <= '0';
        elsif rising_edge(mclk) then
            state <= next_state;
            count := count + 1;
            pwm <= '1' when (count(13 downto 7) < absolute(6 downto 0)) else '0';
        end if;
    end process CLK_REGISTER; 

    NEXT_STATE_CL: process(all) is
    begin
        case state is
            when reverse_idle =>
                next_state <= reverse when (signed(duty_cycle) < 0) else forward_idle;
            when forward_idle => 
                next_state <= forward when (signed(duty_cycle) > 0) else reverse_idle;
            when forward =>
                next_state <= forward_idle when (signed(duty_cycle) <= 0);
            when reverse =>
                next_state <= reverse_idle when (signed(duty_cycle) >= 0);
        end case;
    end process NEXT_STATE_CL;

    OUTPUT_CL: process(all) is
    begin
        case state is
            when reverse_idle =>
                en <= '0';
                dir <= '0';
            when forward_idle =>
                en <= '0';
                dir <= '1';
            when forward =>
                en <= pwm;
                dir <= '1';
            when reverse =>
                en <= pwm;
                dir <= '0';
        end case;
    end process OUTPUT_CL;
end architecture;