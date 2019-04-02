LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux2 IS
	PORT
	(
		data0x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data1x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data2x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data3x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data4x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		sel		   : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END mux2;

architecture ckt of mux2 is 
begin

   result <=   data0x when (sel = "000") else
					data1x when (sel = "001") else
					data2x when (sel = "010") else
					data3x when (sel = "011") else
					data4x;

end ckt;