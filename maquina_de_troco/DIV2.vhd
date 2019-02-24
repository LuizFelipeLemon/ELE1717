library ieee ;
use ieee . std_logic_1164 .all;

entity DIV2 is
    port (clk_in            : in  std_logic ;
          clk_out1,clk_out2 : out std_logic );
end DIV2;


architecture ckt of DIV2 is
    signal ax,ax2 : std_logic := '0';
    

begin
    --ax1 <= '0';
	 --ax2 <= '0';
    process (clk_in)
        variable cnt  : integer range 0 to 13500000 := 0;
		  variable cnt2 : integer range 0 to 27500000 := 0;
       begin
            --ax1 <= '0';
				--ax2 <= '0';
            if (rising_edge(clk_in)) then
					if(cnt  = 13500000)  then
						cnt := 0;
						ax <= not ax;
					else
						cnt  := cnt + 1;end if;
					if (cnt2 = 27500000)  then
						cnt2 := 0;
						ax2 <= not ax2;
					else
						cnt2 := cnt2 + 1;end if;
            end if;
    end process ;
    clk_out1 <= ax;
	 clk_out2 <= ax2;
end ckt ;