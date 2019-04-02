LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY SP IS
	PORT
	(
		count		   : IN STD_LOGIC;
		clk		   : IN STD_LOGIC;
		push_pop    : IN STD_LOGIC;
		sel		   : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		out_SP		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END SP;

ARCHITECTURE ckt OF SP IS

COMPONENT reg IS
	PORT(
			 DIN : in std_logic_vector(7 downto 0); -- system inputs
			 DOUT : out std_logic_vector(7 downto 0); -- system outputs
			 ENABLE : in std_logic; -- enable
			 CLK,RESET : in std_logic
		  ); -- clock and reset
		  
 end COMPONENT;
 
 COMPONENT mux1 IS
	PORT
	(
		data0x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data1x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data2x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data3x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		sel		   : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT add IS
PORT
	(
		add_sub		: IN STD_LOGIC ;
		dataa		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END COMPONENT;

SIGNAL mux_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL reg_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL add_out : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
	
	SP_reg : reg  port map(mux_out,reg_out,count,clk,'0');
	SP_adder : add  port map(push_pop,reg_out,"00000001",add_out);
	SP_mux : mux1 port map("11100111",add_out,"00000000","00000000",sel,mux_out);
	out_SP <= reg_out;

end ckt;