library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture pipeline of grayscale is
    signal next_Y, r_Y               : unsigned(N-1 downto 0);
    signal next_valid, valid_pipelined, r_valid,
           next_overflow, r_overflow : std_logic;
    signal i_R, i_R_pipelined,
           i_G, i_G_pipelined,
           i_B, i_B_pipelined        : unsigned(2*N - 1 downto 0);
    
begin
    -- output from registers
    Y        <= std_logic_vector(r_Y);
    overflow <= r_overflow;
    Y_valid  <= r_valid;
    
    REG_ASSIGNMENT: process(clk) is  
    begin 
        if rising_edge(clk) then 
            if reset then
                i_R_pipelined <= (others => '0');
                i_G_pipelined <= (others => '0');
                i_B_pipelined <= (others => '0');
                valid_pipelined <= '0';

                r_Y        <= (others => '0');
                r_valid    <= '0';
                r_overflow <= '0';
            else
                i_R_pipelined <= i_R;
                i_G_pipelined <= i_G;
                i_B_pipelined <= i_B;
                valid_pipelined <= RGB_valid;

                r_Y        <= next_Y;
                r_overflow <= next_overflow;
                r_valid    <= next_valid;
            end if;
        end if;
    end process; 
    
    CALCULCATION: process (all) is
        variable i_sum  : unsigned(2*N+1 downto 0);
        variable i_overflow   : std_logic; 
    begin
        i_R <= unsigned(WR) * unsigned(R);
        i_G <= unsigned(WG) * unsigned(G);
        i_B <= unsigned(WB) * unsigned(B);

        i_sum := unsigned("00" & i_R_pipelined) + unsigned("00" & i_G_pipelined) + unsigned("00" & i_B_pipelined);
        i_overflow := or(i_sum(i_sum'left downto i_sum'left-1)); 
        next_Y <= (others => '1') when i_overflow else i_sum(2*N-1 downto N);
        next_overflow <= i_overflow;
        next_valid <= valid_pipelined;
    end process;

end architecture pipeline;