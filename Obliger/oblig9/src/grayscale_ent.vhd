library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity grayscale is
  generic ( N : natural := 8);
  port(
    reset, clk           : in  std_logic;
    R, G, B, WR, WG, WB  : in  std_logic_vector(N-1 downto 0);
    RGB_valid            : in  std_logic;
    Y                    : out std_logic_vector(N-1 downto 0);     
    overflow, Y_valid    : out std_logic
  );
end entity grayscale;