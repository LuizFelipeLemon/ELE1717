LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY processor IS
	PORT
	(
		r,clk : in std_logic;
		address_b		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data_b		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren_b		: IN STD_LOGIC  := '0';
		q_b		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		C        : OUT STD_LOGIC;                    -- ULA
		Z        : OUT STD_LOGIC;                    -- ULA

		t_op_out : OUT std_LOGIC_VECTOR(7 downto 0);    -- OPCODE Register
		t_op_ld  : OUT STD_LOGIC;                       -- OPCODE Register
		t_op1_out : OUT std_LOGIC_VECTOR(7 downto 0);    -- OPERAND 1 Register
		t_op1_ld  : OUT STD_LOGIC;                       -- OPERAND 1 Register
		t_op2_out : OUT std_LOGIC_VECTOR(7 downto 0);    -- OPERAND 2 Register
		t_op2_ld  : OUT STD_LOGIC;                       -- OPERAND 2 Register
		
		t_Aa     :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- RAM
		t_Da     :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- RAM
		t_mem    :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- RAM
		t_Wa,t_clk_d,t_z     :  OUT STD_LOGIC;                    -- RAM

		
		t_count_PC  :  OUT STD_LOGIC;						 --PC
		t_sel_PC :  OUT STD_LOGIC_VECTOR (1 DOWNTO 0); --PC	
		t_count_SP  :  OUT STD_LOGIC;                  --SP
		t_push_pop  :  OUT STD_LOGIC;						 --SP
		t_sel_SP :  OUT STD_LOGIC_VECTOR (1 DOWNTO 0); --SP
		t_OP_sel   :  OUT STD_LOGIC_VECTOR (3 DOWNTO 0); -- ULA
		t_AB_Reg      :   OUT STD_logic_vector(1  downto 0); --ABCD
		t_AB_RegX     :   OUT STD_logic_vector(1  downto 0); --ABCD
		t_W_wr     :   OUT STD_logic;                     --ABCD			
		t_sel_MUX_ABCD    : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
		t_sel_MUX_ABCD_IN : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
		t_sel_MUX_Da      : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
		t_sel_MUX_ULA     : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
		t_sel_MUX_MEM     : OUT STD_LOGIC_VECTOR (2 DOWNTO 0) -- MUXES
		
		
	);
END processor;

ARCHITECTURE ckt OF processor IS

COMPONENT ram IS
	PORT
	(
		address_a		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		address_b		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data_a		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data_b		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren_a		: IN STD_LOGIC  := '0';
		wren_b		: IN STD_LOGIC  := '0';
		q_a		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		q_b		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT datapath is 
	port(
			Aa     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- RAM
			Da     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- RAM
			--Qa     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- RAM
			mem    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  -- RAM
			
			count_PC  : IN STD_LOGIC;						 --PC
		    sel_PC : IN STD_LOGIC_VECTOR (1 DOWNTO 0); --PC	
			
			count_SP  : IN STD_LOGIC;                  --SP
			push_pop  : IN STD_LOGIC;						 --SP
			sel_SP : IN STD_LOGIC_VECTOR (1 DOWNTO 0); --SP
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
			
			sel_MUX_ABCD    : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
			sel_MUX_ABCD_IN : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
			sel_MUX_Da      : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
			sel_MUX_ULA     : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
			sel_MUX_MEM     : IN STD_LOGIC_VECTOR (2 DOWNTO 0)  -- MUXES
	
	);
end COMPONENT;

COMPONENT control_block IS
	PORT
	(
		r,clk : in std_logic;
		Wa,clk_d    : OUT STD_LOGIC;
		
		count_PC  : OUT STD_LOGIC;						 --PC
		sel_PC : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); --PC	
		
		count_SP  : OUT STD_LOGIC;                  --SP
		push_pop  : OUT STD_LOGIC;						 --SP
		sel_SP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); --SP
		out_SP    :  IN STD_LOGIC_VECTOR (7 DOWNTO 0); --SP
		
		OP_sel   : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); -- ULA
				
		AB_Reg      : OUT  std_logic_vector(1  downto 0); --ABCD
		AB_RegX     : OUT  std_logic_vector(1  downto 0); --ABCD
		W_wr        : OUT  std_logic;                     --ABCD		
	
		--op_in  : OUT std_LOGIC_VECTOR(7 downto 0);    -- OPCODE Register
		op_out : IN std_LOGIC_VECTOR(7 downto 0);    -- OPCODE Register
		op_ld  : OUT STD_LOGIC;                       -- OPCODE Register

		--op1_in  : OUT std_LOGIC_VECTOR(7 downto 0);    -- OPERAND 1 Register
		op1_out : IN std_LOGIC_VECTOR(7 downto 0);    -- OPERAND 1 Register
		op1_ld  : OUT STD_LOGIC;                       -- OPERAND 1 Register
		
		--op2_in  : OUT std_LOGIC_VECTOR(7 downto 0);    -- OPERAND 2 Register
		op2_out : IN std_LOGIC_VECTOR(7 downto 0);    -- OPERAND 2 Register
		op2_ld  : OUT STD_LOGIC;                       -- OPERAND 2 Register
		
		const  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		const2  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		
		sel_MUX_ABCD    : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
		sel_MUX_ABCD_IN : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
		sel_MUX_Da      : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
		sel_MUX_ULA     : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
		sel_MUX_MEM     : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)  -- MUXES
		
	);
END COMPONENT;


COMPONENT ffd is
    port(
         clk,d,p,c : in  std_logic;
         q         : out std_logic
        );
end COMPONENT;




SIGNAL Aa     :  STD_LOGIC_VECTOR(7 DOWNTO 0); -- RAM
SIGNAL Da     :  STD_LOGIC_VECTOR(7 DOWNTO 0); -- RAM
--SIGNAL Qa     :  STD_LOGIC_VECTOR(7 DOWNTO 0); -- RAM
SIGNAL mem    :  STD_LOGIC_VECTOR(7 DOWNTO 0); -- RAM
SIGNAL Wa     :  STD_LOGIC;                    -- RAM

-- Coisas do datapath

SIGNAL count_PC  :  STD_LOGIC;						 --PC
SIGNAL sel_PC :  STD_LOGIC_VECTOR (1 DOWNTO 0); --PC	

SIGNAL count_SP  :  STD_LOGIC;                  --SP
SIGNAL push_pop  :  STD_LOGIC;						 --SP
SIGNAL sel_SP :  STD_LOGIC_VECTOR (1 DOWNTO 0); --SP
SIGNAL out_SP          : STD_LOGIC_VECTOR (7 DOWNTO 0);


SIGNAL OP_sel   :  STD_LOGIC_VECTOR (3 DOWNTO 0); -- ULA

SIGNAL AB_Reg      :   std_logic_vector(1  downto 0); --ABCD
SIGNAL AB_RegX     :   std_logic_vector(1  downto 0); --ABCD
SIGNAL W_wr     :   std_logic;                     --ABCD

SIGNAL  op_out :  STD_LOGIC_VECTOR(7 downto 0);    -- OPCODE Register
SIGNAL  op_ld  :  STD_LOGIC;                       -- OPCODE Register

SIGNAL  op1_out :  STD_LOGIC_VECTOR(7 downto 0);    -- OPERAND 1 Register
SIGNAL  op1_ld  :  STD_LOGIC;                       -- OPERAND 1 Register

SIGNAL  op2_out :  STD_LOGIC_VECTOR(7 downto 0);    -- OPERAND 2 Register
SIGNAL  op2_ld  :  STD_LOGIC;                       -- OPERAND 2 Register

SIGNAL const  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL const2  :  STD_LOGIC_VECTOR(7 DOWNTO 0);

SIGNAL  sel_MUX_ABCD    : STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
SIGNAL  sel_MUX_ABCD_IN : STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
SIGNAL  sel_MUX_Da      : STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
SIGNAL  sel_MUX_ULA     : STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
SIGNAL  sel_MUX_MEM     : STD_LOGIC_VECTOR (2 DOWNTO 0); -- MUXES

SIGNAL clk_d, Z_q : STD_LOGIC;



begin 

	ram1 : ram PORT MAP(Aa,address_b,clk,Da,data_b,Wa,'0',mem,q_b);

	DPTH : datapath PORT MAP(Aa,Da,mem,count_PC,sel_PC,count_SP,push_pop,sel_SP,out_SP,C,Z_q,OP_sel,clk,
							 AB_Reg,AB_RegX,W_wr,open,open,open,op_out,op_ld,op1_out,op1_ld,
							 op2_out,op2_ld,const,const2,sel_MUX_ABCD,sel_MUX_ABCD_IN,sel_MUX_Da,sel_MUX_ULA,    
							 sel_MUX_MEM);

	ctr : control_block PORT MAP(r,clk,Wa,clk_d,count_PC,sel_PC,count_SP,push_pop,sel_SP,out_SP,OP_sel,
	AB_Reg,AB_RegX,W_wr,op_out,op_ld,op1_out,op1_ld,
	op2_out,op2_ld,const,const2,sel_MUX_ABCD,sel_MUX_ABCD_IN,sel_MUX_Da,sel_MUX_ULA,    
	sel_MUX_MEM);

	fili : ffd PORT MAP(clk AND clk_d,Z_q,'1','1',Z);

	t_op_out  <= op_out ;
	t_op_ld   <= op_ld;
	t_op1_out <= op1_out;
	t_op1_ld  <= op1_ld ;
	t_op2_out <= op2_out;
	t_op2_ld  <= op2_ld ;

	t_count_PC <= count_PC ;
	t_sel_PC <= sel_PC ;
	t_count_SP <= count_SP ;
	t_push_pop <= push_pop ;
	t_sel_SP  <= sel_SP  ;
	t_OP_sel   <= OP_sel   ;
	t_AB_Reg   <= AB_Reg   ;
	t_AB_RegX  <= AB_RegX  ;
	t_W_wr     <= W_wr     ;
	t_sel_MUX_ABCD   <= sel_MUX_ABCD   ;
	t_sel_MUX_ABCD_IN<= sel_MUX_ABCD_IN;
	t_sel_MUX_Da     <= sel_MUX_Da     ;
	t_sel_MUX_ULA    <= sel_MUX_ULA    ;
	t_sel_MUX_MEM    <= sel_MUX_MEM    ;
	t_mem <= mem;

	t_Aa <= Aa ;
	t_Da <= Da ;
	t_mem<= mem;
	t_Wa <= Wa ;
	t_clk_d <= clk_d;
	t_z <= z_q;

END ckt;

