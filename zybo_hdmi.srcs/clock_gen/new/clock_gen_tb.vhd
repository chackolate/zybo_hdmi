----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/11/2022 03:39:01 PM
-- Design Name: 
-- Module Name: clock_gen_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
entity clock_gen_tb is
	--  Port ( );
end clock_gen_tb;

architecture Behavioral of clock_gen_tb is

	signal clk, serclk, pixclk : std_logic;
	constant clk_period        : time := 8 ns;

begin

	clocking : process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

	clock0 : entity work.clock_gen
		generic map(CLKIN_PERIOD => 8.000, CLK_MULTIPLY => 59, CLK_DIVIDE => 5, CLKOUT0_DIV => 4, CLKOUT1_DIV => 20)
		port map(clk_i => clk, clk0_o => serclk, clk1_o => pixclk);

end Behavioral;