library ieee;
use ieee.std_logic_1164.all;

entity fsm is
    generic(WIDTH : natural := 8);
    port (
        clk : in std_logic;
        SS : in std_logic;
        halfcount : in std_logic;
        mincount : in std_logic;
        data : in std_logic_vector(WIDTH -1 downto 0);
        load : out std_logic;
        valid : out std_logic;
        reset_count : out std_logic
    );
end entity fsm;

architecture RTL of fsm is
    constant OP_NOP : std_logic_vector(WIDTH-1 downto 0) := x"00";
    constant OP_FETCH : std_logic_vector(WIDTH-1 downto 0) := x"01";
    constant OP_PUT : std_logic_vector(WIDTH-1 downto 0) := x"02";
    constant OP_PASS : std_logic_vector(WIDTH-1 downto 0) := x"03";

    type t_state is (read_op, put, transmit);
    signal fsm_state, next_state : t_state;
begin
    fsm_state <= next_state when rising_edge(clk);

    process(all)
    begin
        next_state <= fsm_state;
        if SS then
            next_state <= read_op;
        else
            case fsm_state is
                when read_op =>
                    if halfcount then
                        next_state <=
                            put when data = OP_PUT else
                            transmit when data = OP_FETCH else
                            read_op when data = OP_NOP else
                            transmit;
                    end if;
                when put | transmit =>
                    next_state <= read_op when mincount;
                when others =>
                    next_state <= read_op;
            end case;
        end if ;
    end process;

    process(all)
    begin
        load <= '0';
        valid <= '0';
        reset_count <= SS;
        case fsm_state is
            when read_op =>
                load <= '1' when halfcount = '1' and data = OP_FETCH;
                reset_count <= '1' when halfcount = '1' and data = OP_NOP;
            when put =>
                valid <= '1' when mincount;
            when others =>
                null;
        end case;
    end process;
end architecture RTL;