library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity vga_out is
    port(
        CLK    : in std_logic;
        RST    : in std_logic;
        VSYNCX : out std_logic;
        HSYNCX : out std_logic;
		  DCLK   : inout std_logic;
--		       : out std_logic;
        RED    : out std_logic_vector(3 downto 0);
        GREEN  : out std_logic_vector(3 downto 0);
        BLUE   : out std_logic_vector(3 downto 0)
    );
end vga_out;


architecture RTL of vga_out is --LCD(ATM0430D25)--SVGA--VGA
    constant H_SYNC_PULSE : integer := 5;--128;--96;
    constant H_BACK_PORCH : integer := 43;--88;--48;
    constant H_FRONT_PORCH : integer := 8;--40;--16;
    constant H_ACTIVE_VIDEO : integer := 480;--800;--640;
    --constant H_SUM  : integer := (H_SYNC_PULSE + H_BACK_PORCH + H_FRONT_PORCH + H_ACTIVE_VIDEO);
	 constant H_SUM  : integer := (H_BACK_PORCH + H_FRONT_PORCH + H_ACTIVE_VIDEO);

    constant V_SYNC_PULSE : integer := 10;--4;--2;
    constant V_BACK_PORCH : integer := 12;--23;--33;
    constant V_FRONT_PORCH : integer := 4;--1;--10;
    constant V_ACTIVE_VIDEO : integer := 272;--600;--480;
    constant V_SUM  : integer := (V_SYNC_PULSE + V_BACK_PORCH + V_FRONT_PORCH + V_ACTIVE_VIDEO);
    
	 signal count : std_logic_vector(2 downto 0) := (others => '0');
	 
--    reg [11:0] hcount, vcount;
    signal hcount, vcount : std_logic_vector(11 downto 0) := (others => '0');
--    wire pclk;
--    signal pclk : std_logic;
--    assign pclk = clk;


begin
--    pclk <= CLK;
	 
--    pclk <= count(2);
      DCLK <= count(2);
--Divider
    process (CLK) begin
        if(rising_edge(CLK)) then
            if (RST = '1') then
                count <= (others => '0');
            else
                count <= count + 1;
            end if;
        end if;
    end process;



--    assign hsyncx = (hcount <= H_SYNC_PULSE) ? 1 : 0;
HSYNCX <= '0' when (hcount <= H_SYNC_PULSE) else '1';
--    always @ (posedge pclk or posedge rst) begin
--        if (rst)
--            hcount <= 10'd0;
--        else if (hcount == H_SUM)
--            hcount <= 10'd0;
--        else
--            hcount <= hcount + 1;
--    end
    process (DCLK) begin
        if(rising_edge(DCLK)) then
            if (RST = '1') then
                hcount <= (others => '0');
            else
                if conv_integer(hcount) = H_SUM then
                    hcount <= (others => '0');
                else
                    hcount <= hcount + 1;
                end if;
            end if;
        end if;
    end process;

--    assign vsyncx =  (vcount < V_SYNC_PULSE) ? 1 : 0;
VSYNCX <= '0' when (vcount <= V_SYNC_PULSE) else '1';
--    always @ (posedge pclk or posedge rst) begin
--        if (rst)
--            vcount <= 10'd0;
--        else if (hcount == H_SUM) begin
--            if (vcount == V_SUM)
--                 vcount <= 10'd0;
--            else
--                 vcount <= vcount + 1;
--            end
--        else
--            vcount <= vcount;
--    end
    process (DCLK) begin
        if(rising_edge(DCLK)) then
            if (RST = '1') then
                vcount <= (others => '0');
            else
                if (conv_integer(hcount) = H_SUM) then
                    if (conv_integer(vcount) = V_SUM) then
                        vcount <= (others => '0');
                    else
                        vcount <= vcount + 1;
                    end if;
                --else
                    --vcount <= vcount;
                end if;
            end if;
        end if;
    end process;


--    always @ (posedge pclk or posedge rst) begin
--        if (rst) begin
--            red <= 4'b0000;
--            green <= 4'b0000;
--            blue <= 4'b0000;
--        end
--        else if ( ( ((V_SYNC_PULSE+ V_BACK_PORCH) <= vcount) && (vcount <= (V_SYNC_PULSE+ V_BACK_PORCH+V_ACTIVE_VIDEO)) )
--        && ( ((H_SYNC_PULSE + H_BACK_PORCH) <= hcount) && (hcount <= (H_SYNC_PULSE+ H_BACK_PORCH+H_ACTIVE_VIDEO)) ) ) begin
--                if (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+200)) begin
--                    red <= 4'b1111;
--                    green <= 4'b0000;
--                    blue <= 4'b0000;
--                end
--                else if (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+400)) begin
--                    red <= 4'b0000;
--                    green <= 4'b1111;
--                    blue <= 4'b0000;
--                end
--                else if (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+600)) begin
--                    red <= 4'b0000;
--                    green <= 4'b0000;
--                    blue <= 4'b1111;
--                end
--                else begin
--                    red <= 4'b0000;
--                    green <= 4'b0000;
--                    blue <= 4'b0000;
--                end
--          end
--        else begin
--            red <= 4'b0000;
--            green <= 4'b0000;
--            blue <= 4'b0000;
--        end
--    end
    process (DCLK) begin
        if (rising_edge(DCLK)) then
            if (RST = '1') then
                RED <= B"0000"; --(others => '0')
                GREEN <= B"0000";
                BLUE <= B"0000";
            else
                --if ( ( ((V_SYNC_PULSE+ V_BACK_PORCH) <= vcount) and (vcount <= (V_SYNC_PULSE+ V_BACK_PORCH+V_ACTIVE_VIDEO)) )
                --and ( ((H_SYNC_PULSE + H_BACK_PORCH) <= hcount) and (hcount <= (H_SYNC_PULSE+ H_BACK_PORCH+H_ACTIVE_VIDEO)) ) ) then
					 if ( ( ((V_BACK_PORCH) <= vcount) and (vcount <= (V_BACK_PORCH + V_ACTIVE_VIDEO)) )
                and ( ((H_BACK_PORCH) <= hcount) and (hcount <= (H_BACK_PORCH + H_ACTIVE_VIDEO)) ) ) then
--                    red <= B"1111";
--                    green <= B"0000"; --(others => '1')
--                    blue <= B"0000";
                    if (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+60)) then--black
					         RED <= B"0000";
                        GREEN <= B"0000";
                        BLUE <= B"0000";
                    elsif (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+120)) then--red
                        RED <= B"1111";
                        GREEN <= B"0000";
                        BLUE <= B"0000";
                    elsif (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+180)) then--blue
					         RED <= B"0000";
                        GREEN <= B"1111";
                        BLUE <= B"0000";
                    elsif (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+240)) then--green
					         RED <= B"0000";
                        GREEN <= B"0000";
                        BLUE <= B"1111";
                    elsif (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+300)) then--yellow
                        RED <= B"1111";
                        GREEN <= B"1111";
                        BLUE <= B"0000";
                    elsif (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+360)) then--cyan
                        RED <= B"0000";
                        GREEN <= B"1111";
                        BLUE <= B"1111";
                    elsif (hcount < (H_SYNC_PULSE+ H_BACK_PORCH+420)) then--magenta
                        RED <= B"1111";
                        GREEN <= B"0000";
                        BLUE <= B"1111";
                    else--while
                        RED <= B"1111";
                        GREEN <= B"1111";
                        BLUE <= B"1111";                   
                    end if;
                else
                    RED <= B"0000";
                    GREEN <= B"0000";
                    BLUE <= B"0000";
                end if;
            end if;
        end if;
    end process;
    
end RTL;