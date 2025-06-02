library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fsm is
    port (
        clk, rstn : in std_logic;
        sdata : in std_logic;
        tvalid : out std_logic;
        tdata : out std_logic_vector(7 downto 0)
    );
end entity fsm;

architecture rtl of fsm is
    type state_type is (s_idle, s_wait, s_valid);
    signal state, next_state : state_type;

    signal shiftreg : std_logic_vector(7 downto 0);
    signal count, next_count : unsigned(7 downto 0) := (others => '0');
begin
    REG_ASSIGNMENT: process(clk, rstn) is
    begin
        if rstn = '0' then
            count <= (others => '0');
            state <= s_idle;
            shiftreg <= (others => '0');
        elsif rising_edge(clk) then
            count <= next_count;
            state <= next_state;
            shiftreg <= shiftreg(6 downto 0) & sdata;
        end if;
    end process REG_ASSIGNMENT;

    NEXT_STATE_CL: process(all) is
    begin
        case state is
            when s_idle =>
                next_state <= s_wait when shiftreg = x"AA" else s_idle;
            when s_wait =>
                if count = 6 then
                    next_state <= s_idle when shiftreg(6 downto 0) & sdata = x"FF" else s_valid;
                else
                    next_state <= s_wait;
                end if;
            when s_valid =>
                next_state <= s_wait;
            when others =>
                next_state <= s_idle;
        end case;
    end process NEXT_STATE_CL;

    OUTPUT_CL: process(all) is
    begin
        tvalid <= '0';
        tdata <= (others => '0');
        case state is
            when s_idle =>
                null;
            when s_wait =>
                next_count <= (others => '0') when count = 6 else count + 1;
            when s_valid =>
                tvalid <= '1';
                tdata <= shiftreg;
        end case;
    end process OUTPUT_CL;
end architecture;