LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux1 IS
	PORT
	(
		data0x		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		data1x		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		sel		: IN STD_LOGIC ;
		result		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END mux1;

architecture ckt of mux1 is 
begin
result <= data0x WHEN sel = '0' else data1x;

end ckt;