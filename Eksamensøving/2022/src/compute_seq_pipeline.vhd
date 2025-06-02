library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity compute_seq_pipeline is
    port (
        clk, reset, vdata : in std_logic;
        a, b, c, d : in std_logic_vector(15 downto 0);
        result : out std_logic_vector(17 downto 0);
        vresult : out std_logic
    );
end entity compute_seq_pipeline;

architecture rtl of compute_seq_pipeline is
    signal next_ab, r_ab, next_cd, r_cd : unsigned(16 downto 0);
    signal vdata_pipelined, r_vdata : std_logic;
    signal next_result, r_result : unsigned(17 downto 0);
begin
    result <= std_logic_vector(r_result);
    vresult <= r_vdata;

    process(clk, reset) is
    begin
        if rising_edge(clk) then
            if reset then
                r_result <= (others => '0');
                r_vdata <= '0';

                r_ab <= (others => '0');
                r_cd <= (others => '0');
                vdata_pipelined <= '0';
            else
                r_result <= std_logic_vector(next_result);
                r_vdata <= vdata_pipelined;

                r_ab <= unsigned('0' & a) + unsigned('0' & b);
                r_cd <= unsigned('0' & c) + unsigned('0' & d);
                vdata_pipelined <= v_data;
            end if;
        end if;
    end process;

    next_result <= (others => '0') when not vdata_pipelined else unsigned('0' & r_ab) + unsigned('0' & r_cd);  
end architecture;