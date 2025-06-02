library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity self_test_system is
    port (
        mclk, reset : in std_logic;
        dir_synch, en_synch : out std_logic
    );
end entity self_test_system;

architecture structural of self_test_system is
    signal duty_cycle : std_logic_vector(7 downto 0);

    signal dir, en : std_logic;
begin
    STM: entity work.self_test_module
    port map (
        mclk => mclk,
        reset => reset,
        duty_cycle => duty_cycle
    );

    PWM: entity work.pulse_width_modulator
    port map (
        mclk => mclk,
        reset => reset,
        duty_cycle => duty_cycle,
        dir => dir,
        en => en
    );

    OUT_SYNCH: entity work.output_synchronizer
    port map (
        mclk => mclk,
        reset => reset,
        dir => dir,
        en => en,
        dir_synch => dir_synch,
        en_synch => en_synch
    );
end architecture;