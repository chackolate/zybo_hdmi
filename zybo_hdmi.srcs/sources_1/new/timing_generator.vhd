library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity timing_generator is
	generic (
		RESOLUTION  : string  := "HD720P";
		GEN_PIX_LOC : boolean := true;
		OBJECT_SIZE : natural := 16
	);
	port (
		clk          : in std_logic;
		hsync, vsync : out std_logic;
		video_active : out std_logic;
		pixel_x      : out std_logic_vector(OBJECT_SIZE - 1 downto 0);
		pixel_y      : out std_logic_vector(OBJECT_SIZE - 1 downto 0)
	);
end timing_generator;

architecture Behavioral of timing_generator is

	type video_timing_type is record
		H_VIDEO : integer;
		H_FP    : integer;
		H_SYNC  : integer;
		H_BP    : integer;
		H_TOTAL : integer;
		V_VIDEO : integer;
		V_FP    : integer;
		V_SYNC  : integer;
		V_BP    : integer;
		V_TOTAL : integer;
		H_POL   : std_logic;
		V_POL   : std_logic;
		ACTIVE  : std_logic;
	end record;

	-- HD720p timing
	--      screen area 1280x720 @60 Hz
	--      horizontal : 1280 visible + 72 front porch (fp) + 80 hsync + 216 back porch = 1648 pixels
	--      vertical   :  720 visible +  3 front porch (fp) +  5 vsync +  22 back porch =  750 pixels
	--      Total area 1648x750
	--      clk input should be 74.25 MHz signal (1650 * 750 * 60)
	--      hsync and vsync are positive polarity
	constant HD720P_TIMING : video_timing_type := (
		H_VIDEO => 1280,
		H_FP    => 72,
		H_SYNC  => 80,
		H_BP    => 216,
		H_TOTAL => 1648,
		V_VIDEO => 720,
		V_FP    => 3,
		V_SYNC  => 5,
		V_BP    => 22,
		V_TOTAL => 750,
		H_POL   => '1',
		V_POL   => '1',
		ACTIVE  => '1'
	);

	-- VGA timing
	--      screen area 640x480 @60 Hz
	--      horizontal : 640 visible + 16 front porch (fp) + 96 hsync + 48 back porch = 800 pixels
	--      vertical   : 480 visible + 10 front porch (fp) +  2 vsync + 33 back porch = 525 pixels
	--      Total area 800x525
	--      clk input should be 25 MHz signal (800 * 525 * 60)
	--      hsync and vsync are negative polarity
	constant VGA_TIMING : video_timing_type := (
		H_VIDEO => 640,
		H_FP    => 16,
		H_SYNC  => 96,
		H_BP    => 48,
		H_TOTAL => 800,
		V_VIDEO => 480,
		V_FP    => 10,
		V_SYNC  => 2,
		V_BP    => 33,
		V_TOTAL => 525,
		H_POL   => '0',
		V_POL   => '0',
		ACTIVE  => '1'
	);

	--h/v counters
	signal hcount, vcount : unsigned(OBJECT_SIZE - 1 downto 0) := (others => '0');
	signal timings        : video_timing_type                  := HD720P_TIMING;

begin

	timings <=
		HD720P_TIMING when RESOLUTION = "HD720P" else
		VGA_TIMING when RESOLUTION = "VGA";

	--pixel counters
	process (clk) is
	begin
		if (rising_edge(clk)) then
			if (hcount = timings.H_TOTAL) then --if horizontal counter is max, reset to 0
				hcount <= (others => '0');
				if (vcount = timings.V_TOTAL) then --if vertical counter is max, reset to 0
					vcount <= (others => '0');
				else
					vcount <= vcount + 1; --increment vertical
				end if;
			else
				hcount <= hcount + 1; --increment horizontal
			end if;
		end if;
	end process;

	--outputs (video_active, hsync, vsync)
	video_active <= timings.ACTIVE when (hcount < timings.H_VIDEO) and (vcount < timings.V_VIDEO) else
		not timings.ACTIVE;

	hsync <= timings.H_POL when (hcount >= timings.H_VIDEO + timings.H_FP) and (hcount < timings.H_TOTAL - timings.H_BP) else
		not timings.H_POL;

	vsync <= timings.V_POL when (vcount >= timings.V_VIDEO + timings.V_FP) and (vcount < timings.V_TOTAL - timings.V_BP) else
		not timings.V_POL;

	pixel_x <= std_logic_vector(hcount) when hcount < timings.H_VIDEO else
		(others => '0');

	pixel_y <= std_logic_vector(vcount) when vcount < timings.V_VIDEO else
		(others => '0');

end Behavioral;