LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux1 IS
	PORT
	(
		data0x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data1x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data2x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data3x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		sel		   : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END mux1;

architecture ckt of mux1 is 
begin

   result <=   data0x when (sel = "00") else
					data1x when (sel = "01") else
					data2x when (sel = "10") else
					data3x;

end ckt;