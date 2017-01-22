library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_vhd_lcd is
    port(
	 	  CHK    : out std_logic;
	     CLK    : in std_logic;
        RST    : in std_logic;
        VSYNCX : out std_logic;
        HSYNCX : out std_logic;
		  DCLK   : out std_logic;
        RED    : out std_logic_vector(3 downto 0);
        GREEN  : out std_logic_vector(3 downto 0);
        BLUE   : out std_logic_vector(3 downto 0)
    );
end vga_vhd_lcd;

architecture RTL of vga_vhd_lcd is
  --signal CLK50M : std_logic;
  
  component vga_out is
  port (
    CLK : in STD_LOGIC;
    RST : in STD_LOGIC;
    VSYNCX : out STD_LOGIC;
    HSYNCX : out STD_LOGIC;
	 DCLK   : out std_logic;
    RED : out STD_LOGIC_VECTOR ( 3 downto 0 );
    GREEN : out STD_LOGIC_VECTOR ( 3 downto 0 );
    BLUE : out STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  end component vga_out;
  
begin

  CHK <= '1';

  vga_out_1 :vga_out
  port map (
   CLK => CLK,--CLK50M,
   RST => RST,
   VSYNCX => VSYNCX,
   HSYNCX => HSYNCX,
	DCLK => DCLK,
   RED (3 downto 0) => RED (3downto 0),
   GREEN (3 downto 0) => GREEN (3downto 0),
   BLUE (3 downto 0) => BLUE (3downto 0)
  );

end RTL;
