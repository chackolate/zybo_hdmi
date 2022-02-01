library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity timing_generator_tb is
	--  Port ( );
end timing_generator_tb;

architecture Behavioral of timing_generator_tb is

begin

	timing_gen : entity work.timing_generator
		generic map(
			RESOLUTION  => "VGA",
			GEN_PIX_LOC => true,
			OBJECT_SIZE =>
		)
	end Behavioral;