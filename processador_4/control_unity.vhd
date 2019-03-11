LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity control_unity is
port(
	r,clk : in std_logic;
	
	addr : out std_logic_vector(7 downto 0);
	data : in std_logic_vector(15 downto 0);
	I_rd : out std_logic;
	
	RF_s,RF_W_wr,RF_Rp_rd,RF_Rq_rd,alu_s0,D_rd,D_wr       : out std_logic;
	RF_W_addr,RF_Rp_addr,RF_Rq_addr                       : out std_logic_vector(3 downto 0);
	D_addr : out std_logic_vector(7 downto 0)
);
end control_unity;


architecture ckt of control_unity is 

COMPONENT contador IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		cnt_en		: IN STD_LOGIC ;
		sclr		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT registrador IS
	PORT
	(
		data_in		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clk,ld		: IN STD_LOGIC ;
		data_out		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT control_block is
	port
	(
		r,clk : in std_logic;
		PC_inc,PC_clr,IR_ld,I_rd : out std_logic;
		IR : in std_logic_vector(15 downto 0);
		RF_s,RF_W_wr,RF_Rp_rd,RF_Rq_rd,alu_s0,D_rd,D_wr       : out std_logic;
		RF_W_addr,RF_Rp_addr,RF_Rq_addr                       : out std_logic_vector(3 downto 0);
		D_addr : out std_logic_vector(7 downto 0)
	);
end COMPONENT;

signal PC_inc,PC_clr,IR_ld : std_logic;
signal IR_data : std_logic_vector(15 downto 0);


begin

	--Bloco de Controle
	BC : control_block port map(r,clk,PC_inc,PC_clr,IR_ld,I_rd,IR_data,RF_s,RF_W_wr,RF_Rp_rd,RF_Rq_rd,alu_s0,D_rd,D_wr,RF_W_addr,RF_Rp_addr,RF_Rq_addr,D_addr);
	
	--Program Counter
	PC : contador port map(clk,PC_inc,not PC_clr,addr);
	
	-- Instruction Register
	IR : registrador port map(data,clk,IR_ld,IR_data);
	
	
	
end ckt;