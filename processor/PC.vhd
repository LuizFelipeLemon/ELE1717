LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY PC IS
	PORT
	(
		count		   : IN STD_LOGIC;
		clk		   : IN STD_LOGIC;
		sel		   : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		mem		   : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		const	      : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		const2      : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		out_PC		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END PC;

ARCHITECTURE ckt OF PC IS

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
		cout		: OUT STD_LOGIC ;
		result		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END COMPONENT;

SIGNAL mux_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL reg_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL add_out : STD_LOGIC_VECTOR(7 DOWNTO 0);


BEGIN
	
	PC_reg : reg  port map(mux_out,reg_out,count,clk,'0');
	PC_adder : add  port map('1',reg_out,"00000001",OPEN,add_out);
	PC_mux : mux1 port map(mem,add_out,const,const2,sel,mux_out);
	out_PC <= reg_out;


END ckt;