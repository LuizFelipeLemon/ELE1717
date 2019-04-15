LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY B_ULA IS
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
END B_ULA;

ARCHITECTURE ckt OF B_ULA IS

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
	
COMPONENT mul IS
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT comp IS
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		aeb		: OUT STD_LOGIC 
	);
END COMPONENT;



SIGNAL OUT_ADDER : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL C_adder : STD_LOGIC;

SIGNAL OUT_INC : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL C_inc : STD_LOGIC;

SIGNAL add_contr   : STD_LOGIC;

SIGNAL OUT_MULT : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL C_mult : STD_LOGIC;

SIGNAL out_ULA   :  STD_LOGIC_VECTOR (7 DOWNTO 0);

SIGNAL OUT_CMP : STD_LOGIC;

SIGNAL SHL,SHR   :  unsigned (7 DOWNTO 0);




BEGIN
	adder : add port map(add_contr,A,B,C_adder,OUT_ADDER);
	inc   : add port map(add_contr,A,"00000001",C_inc,OUT_INC);
	mult  : mul port map(A,B,OUT_MULT); 
	cmpa : comp port map(A,B,OUT_CMP);
	
	
	add_contr <= '1' WHEN (OP_sel = "0000" OR OP_sel = "0011") ELSE '0';
	
	out_ULA <= OUT_ADDER WHEN (OP_sel = "0000" OR OP_sel = "0001") ELSE
				  OUT_MULT(7 DOWNTO 0) WHEN OP_sel = "0010"           ELSE
				  OUT_INC   WHEN (OP_sel = "0011" OR OP_sel = "0100") ELSE
				  A AND B   WHEN OP_sel = "0101"                      ELSE
				  A OR  B   WHEN OP_sel = "0110"                      ELSE
				  A XOR B   WHEN OP_sel = "0111"                      ELSE
				  NOT A 		WHEN OP_sel = "1000"                      ELSE
				  STD_LOGIC_VECTOR(SHL)       WHEN OP_sel = "1001"                      ELSE
				  STD_LOGIC_VECTOR(SHR)       WHEN OP_sel = "1010"                      ELSE
				  "00000000";
				  
	SHL <= unsigned(A) sll to_integer(unsigned(B));
	SHR <= unsigned(A) srl to_integer(unsigned(B));
				
	C <= C_adder WHEN OP_sel = "0000" ELSE
	 not C_adder WHEN OP_sel = "0001" ELSE
	 '1' WHEN (OP_sel = "0010" AND to_integer(unsigned(OUT_MULT(15 DOWNTO 8))) > 0)  ELSE
	 '0' WHEN (OP_sel = "0010" AND to_integer(unsigned(OUT_MULT(15 DOWNTO 8))) = 0)  ELSE
		  C_inc   WHEN OP_sel = "0011" ELSE
	 not C_inc   WHEN OP_sel = "0100" ELSE
	 '0' WHEN (OP_sel = "1011" AND A > B)  ELSE
	 '1' WHEN (OP_sel = "1011" AND B > A)  ELSE
	     '0';
	 
	 Z <= OUT_CMP WHEN OP_sel = "1011" ELSE
	    '1' WHEN out_ULA = "00000000"  ELSE
		  '0';
	 
	 out_ULAM <= out_ULA;
		
	
END ckt;