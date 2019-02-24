library ieee ;
use ieee . std_logic_1164 .all;

entity cofre is 
	port(i, clk : in  std_logic;
		  c     : out std_logic
			);
	
end cofre;

architecture ckt of cofre is

signal coinCounter : std_logic_vector(3 downto 0);
signal eq,ci          : std_logic;

component counter is
		port(
			clock, CLR, inc: in std_logic;
			S: out std_logic_vector(3 downto 0)
		);
end component;

component comapare IS
		PORT(
			dataa		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			datab		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			aeb		: OUT STD_LOGIC 
		);
	END component;

begin

conta :counter port map(
		clock =>     clk, 
		CLR   =>     '1', 
		inc   =>       i,
		S     =>   coinCounter
	);
	
	equals : comapare port map(
		dataa  => coinCounter,
		datab	 =>      "1111",	
		aeb    =>          ci
	);
	c <= not ci;

end ckt;