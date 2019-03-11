LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity ALU is 
	port(
		A,B 		: in  std_logic_vector(15 downto 0);
		s0       : in std_logic;
		saida   : out std_logic_vector(15 downto 0)

	);
end ALU;
	
ARCHITECTURE ckt OF ALU IS

signal sum : STD_LOGIC_VECTOR (15 DOWNTO 0);

COMPONENT somador IS
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END COMPONENT;

begin

	
	
	somador1 : somador port map(A,B,sum);
	
	saida <= A when s0 = '0' else
            sum;


end ckt;