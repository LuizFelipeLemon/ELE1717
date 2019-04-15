LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity datapath is 
	port(
			Aa     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- RAM
			Da     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- RAM
			--Qa     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- RAM
			mem    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  -- RAM
			
			count_PC  : IN STD_LOGIC;						 --PC
		    sel_PC : IN STD_LOGIC_VECTOR (1 DOWNTO 0); --PC	
			
			count_SP  : IN STD_LOGIC;                  --SP
			push_pop  : IN STD_LOGIC;						 --SP
			sel_SP    : IN STD_LOGIC_VECTOR (1 DOWNTO 0); --SP
			out_SP    :  OUT STD_LOGIC_VECTOR (7 DOWNTO 0); --SP

			
			C        : OUT STD_LOGIC;                    -- ULA
		    Z        : OUT STD_LOGIC;                    -- ULA
			OP_sel   : IN STD_LOGIC_VECTOR (3 DOWNTO 0); -- ULA
			
			clk	 : IN STD_LOGIC;
			
			AB_Reg      : in  std_logic_vector(1  downto 0); --ABCD
			AB_RegX     : in  std_logic_vector(1  downto 0); --ABCD
			W_wr     : in  std_logic;                     --ABCD
			
			ULAO     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- TEST
			BEX     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- TEST
			BEY     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- TEST
			
			--op_in  : OUT std_LOGIC_VECTOR(7 downto 0);    -- OPCODE Register
			op_out : OUT std_LOGIC_VECTOR(7 downto 0);    -- OPCODE Register
			op_ld  : IN STD_LOGIC;                       -- OPCODE Register

			--op1_in  : OUT std_LOGIC_VECTOR(7 downto 0);    -- OPERAND 1 Register
			op1_out : OUT std_LOGIC_VECTOR(7 downto 0);    -- OPERAND 1 Register
			op1_ld  : IN STD_LOGIC;                       -- OPERAND 1 Register
			
			--op2_in  : OUT std_LOGIC_VECTOR(7 downto 0);    -- OPERAND 2 Register
			op2_out : OUT std_LOGIC_VECTOR(7 downto 0);    -- OPERAND 2 Register
			op2_ld  : IN STD_LOGIC;                       -- OPERAND 2 Register		
			
			const  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			const2  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			PC_OUT_PROC : OUT std_LOGIC_VECTOR(7 downto 0);
			
			sel_MUX_ABCD    : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
			sel_MUX_ABCD_IN : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
			sel_MUX_Da      : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
			sel_MUX_ULA     : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
			sel_MUX_MEM     : IN STD_LOGIC_VECTOR (2 DOWNTO 0)  -- MUXES
	
	);
end datapath;
	
ARCHITECTURE ckt OF datapath IS

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

COMPONENT mux2 IS
	PORT
	(
		data0x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data1x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data2x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data3x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data4x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data5x		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		sel		   : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END COMPONENT;


COMPONENT PC IS
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
END COMPONENT;

COMPONENT SP IS
	PORT
	(
		count		   : IN STD_LOGIC;
		clk		   : IN STD_LOGIC;
		push_pop    : IN STD_LOGIC;
		sel		   : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		out_SP		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT register_bank IS 
	port(
	BRy      : out std_logic_vector(7 downto 0);
	BRx      : out std_logic_vector(7 downto 0);
	BRz 		: in  std_logic_vector(7 downto 0);
	Reg      : in  std_logic_vector(1  downto 0);
	RegX     : in  std_logic_vector(1  downto 0);
	W_wr     : in  std_logic;
	clk      : in  std_logic;
	clr 	   : in  std_logic
	);
END COMPONENT;

COMPONENT B_ULA IS
	PORT
	(
		A		   : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		B		   : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		C        : OUT STD_LOGIC;
		Z        : OUT STD_LOGIC;
		OP_sel   : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		--SHL,SHR  : OUT   unsigned (7 DOWNTO 0);
		out_ULAM   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END COMPONENT;


 COMPONENT reg is
 port (
		 DIN : in std_logic_vector(7 downto 0); -- system inputs
		 DOUT : out std_logic_vector(7 downto 0); -- system outputs
		 ENABLE : in std_logic; -- enable
		 CLK,RESET : in std_logic
		 );
 end COMPONENT;


SIGNAL out_PC          : STD_LOGIC_VECTOR (7 DOWNTO 0);
--SIGNAL mem : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL out_SP1          : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL out_MUX_ABCD    : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL out_MUX_ABCD_IN : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL out_MUX_ULA     : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL BRy             : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL BRx             : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL ULA             : STD_LOGIC_VECTOR (7 DOWNTO 0);


BEGIN

	ProCnt : PC PORT MAP(count_PC,clk,sel_PC,mem,const,BRy,out_PC);
	
	Stack  : SP PORT MAP(count_SP,clk,push_pop,sel_SP,out_SP1);
	
	MUX_MEM: Mux2 PORT MAP(out_PC,mem,out_MUX_ABCD,out_SP1,const,const2,sel_MUX_MEM,Aa);
	
	MUX_ABC: Mux1 PORT MAP(BRy,BRx,"00000000","00000000",sel_MUX_ABCD,out_MUX_ABCD);
	
	MUX_Da: Mux1 PORT MAP(BRx,mem,const,out_PC,sel_MUX_Da,Da);
	
	MUX_ABCD_IN: Mux1 PORT MAP(mem,ULA,BRx,const,sel_MUX_ABCD_IN,out_MUX_ABCD_IN);
	
	ABCD : register_bank PORT MAP(BRy,BRx,out_MUX_ABCD_IN,AB_Reg,AB_RegX,W_wr,clk,'1');
	
	MUX_ULA: Mux1 PORT MAP(BRx,mem,const,"00000000",sel_MUX_ULA,out_MUX_ULA); 
	
	LULA : B_ULA PORT MAP(BRy,out_MUX_ULA,C,Z,OP_sel,ULA);
	
	op : reg PORT MAP(mem,op_out,'1',op_ld,'0');
	
	op1 : reg PORT MAP(mem,op1_out,'1',op1_ld,'0');
	
	op2 : reg PORT MAP(mem,op2_out,'1',op2_ld,'0');
	
	PC_OUT_PROC <= out_PC;
	
	ULAO <= out_MUX_ABCD_IN; 
	BEX <= BRx;
	BEY <= BRy;
	out_SP <= out_SP1;




END ckt;