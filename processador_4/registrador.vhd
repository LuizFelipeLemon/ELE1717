LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY registrador IS
	PORT
	(
		data_in		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clk,ld		: IN STD_LOGIC ;
		data_out		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END registrador;

architecture ckt of registrador is 
begin
process(clk,ld)
begin

	if rising_edge(clk) and ld='1' then
		data_out <= data_in;
	end if;
	
end process;
end ckt;