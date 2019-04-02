library ieee;
 use ieee.std_logic_1164.all;
 entity reg is

 port (DIN : in std_logic_vector(7 downto 0); -- system inputs
 DOUT : out std_logic_vector(7 downto 0); -- system outputs
 ENABLE : in std_logic; -- enable
 CLK,RESET : in std_logic); -- clock and reset
 end reg;
 -- purpose: Main architecture details for 8bit_reg
 architecture SIMPLE of reg is

 begin -- SIMPLE
	 process(CLK,RESET)

	 begin -- process
		 -- activities triggered by asynchronous reset (active high)
		 if RESET = '1' then
			DOUT <= "00000000";

		 -- activities triggered by rising edge of clock
		 elsif CLK'event and CLK = '1' then
			 if ENABLE='1' then
				DOUT <= DIN;
			 else
				null;
			 end if;
		 end if;
	end process;
 end SIMPLE;