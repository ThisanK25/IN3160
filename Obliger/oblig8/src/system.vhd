library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity system is
    port (
        mclk, reset, sa, sb : in std_logic;
        dir_synch, en_synch, c : out std_logic;
        abcdefg : out std_logic_vector(6 downto 0)
    );
end entity system;

architecture structural of system is
    signal sa_synch, sb_synch, pos_inc, pos_dec : std_logic;
    signal velocity : signed(7 downto 0);
begin
    STS: entity work.self_test_system
    port map (
        mclk => mclk,
        reset => reset,
        dir_synch => dir_synch,
        en_synch => en_synch
    );

    IN_SYNCH: entity work.input_synchronizer
    port map (
        mclk => mclk,
        reset => reset,
        sa => sa,
        sb => sb,
        sa_synch => sa_synch,
        sb_synch => sb_synch
    );

    QD: entity work.quadrature_decoder
    port map (
        mclk => mclk,
        reset => reset,
        sa => sa_synch,
        sb => sb_synch,
        pos_inc => pos_inc,
        pos_dec => pos_dec
    );

    VR: entity work.velocity_reader
    port map (
        mclk => mclk,
        reset => reset,
        pos_inc => pos_inc,
        pos_dec => pos_dec,
        velocity => velocity
    );

    SEG7CTRL: entity work.seg7ctrl
    port map (
        mclk => mclk,
        reset => reset,
        velocity => velocity,
        abcdefg => abcdefg,
        c => c
    );
end architecture;