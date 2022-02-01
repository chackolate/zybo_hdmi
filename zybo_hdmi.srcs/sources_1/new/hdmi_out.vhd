library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

entity hdmi_out is
	generic (
		RESOLUTION  : string  := "VGA"; --VGA
		GEN_PATTERN : boolean := true;  --generate pattern/objects
		GEN_PIX_LOC : boolean := true;  --generate location counters
		OBJECT_SIZE : natural := 16;    --size of objects
		PIXEL_SIZE  : natural := 24     --RGB pixel size (24 bits)
	);
	port (
		clk, rst       : in std_logic;
		clk_p, clk_n   : out std_logic;
		data_p, data_n : out std_logic_vector(2 downto 0)
	);
end hdmi_out;

architecture Behavioral of hdmi_out is

	signal pixclk, serclk   : std_logic;
	signal video_active     : std_logic := '0';
	signal vsync, hsync     : std_logic := '0';
	signal pixel_x, pixel_y : std_logic_vector(OBJECT_SIZE - 1 downto 0);

begin

	--for generating 1x pixclk/5x serclk
	clock : entity work.clock_gen
		generic map(CLKIN_PERIOD => 8.000, CLK_MULTIPLY => 59, CLK_DIVIDE => 5, CLKOUT0_DIV => 4, CLKOUT1_DIV => 20)
		port map(clk_i => clk, clk0_o => serclk, clk1_o => pixclk);

	--	--video timing
	timing : entity work.timing_generator
		generic map(RESOLUTION => RESOLUTION, GEN_PIX_LOC => GEN_PIX_LOC, OBJECT_SIZE => OBJECT_SIZE)
		port map(clk => pixclk, hsync => hsync, vsync => vsync, video_active => video_active, pixel_x => pixel_x, pixel_y => pixel_y);

	--	--tmds signaling
	--	tmds : entity work.rgb2tmds
	--		port map(rst => rst, pixclk => pixclk, serclk => serclk, video_data => video_data, video_active => video_active, hsync => hsync, vsync => vsync, clk_p => clk_p, clk_n => clk_n, data_p => data_p, data_n => data_n);

	--	--pattern generator
	--	pattern : entity work.pattern_generator
	--		port map(clk => pixclk, video_active => video_active, rgb => video_data);
end Behavioral;