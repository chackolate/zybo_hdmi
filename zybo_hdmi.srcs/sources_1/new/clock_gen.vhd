----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2021 02:10:58 PM
-- Design Name: 
-- Module Name: clock_gen - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

entity clock_gen is
	generic (
		CLKIN_PERIOD : real;    --input clock period
		CLK_MULTIPLY : integer; --multiplier
		CLK_DIVIDE   : integer; --divider
		CLKOUT0_DIV  : integer; --serial clock divider
		CLKOUT1_DIV  : integer  --pixel clock divider
	);
	port (
		clk_i  : in std_logic;
		clk0_o : out std_logic;  --serial clock
		clk1_o : out std_logic); --pixel clock
end clock_gen;

architecture Behavioral of clock_gen is

	signal pllclk0, pllclk1 : std_logic;
	signal clkfbout         : std_logic;

begin

	--buffer outputs
	clk0buf : BUFG port map(I => pllclk0, O => clk0_o);
	clk1buf : BUFG port map(I => pllclk1, O => clk1_o);

	clock   : PLLE2_BASE generic map(
		clkin1_period  => CLKIN_PERIOD,
		clkfbout_mult  => CLK_MULTIPLY,
		clkout0_divide => CLKOUT0_DIV,
		clkout1_divide => CLKOUT1_DIV,
		divclk_divide  => CLK_DIVIDE
	)
	port map(
		rst      => '0',
		pwrdwn   => '0',
		clkin1   => clk_i,
		clkfbin  => clkfbout,
		clkfbout => clkfbout,
		clkout0  => pllclk0,
		clkout1  => pllclk1
	);
end Behavioral;