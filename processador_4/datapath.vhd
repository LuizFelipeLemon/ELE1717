LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity datapath is 
	port(
		R_data	: in  std_logic_vector(15 downto 0);
		clk : in std_logic;
		RF_s,RF_W_wr,RF_Rp_rd,RF_Rq_rd,alu_s0       : in std_logic;
		RF_W_addr,RF_Rp_addr,RF_Rq_addr             : in std_logic_vector(3 downto 0);
		RAM_W_data   : out std_logic_vector(15 downto 0)

	);
end datapath;
	
ARCHITECTURE ckt OF datapath IS

COMPONENT ALU is 
	port(
		A,B 		: in  std_logic_vector(15 downto 0);
		s0       : in std_logic;
		saida   : out std_logic_vector(15 downto 0)
	);
end COMPONENT;

COMPONENT register_bank is 
	port(
	Rp_data,Rq_data 		: out std_logic_vector(15 downto 0);
	W_data 		: in  std_logic_vector(15 downto 0);
	W_addr,Rp_addr,Rq_addr : in  std_logic_vector(3  downto 0);
	W_wr,Rp_rd,Rq_rd,clk,clr 	: in  std_logic
	);
end COMPONENT;

COMPONENT mux1 IS
	PORT
	(
		data0x		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		data1x		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		sel		: IN STD_LOGIC ;
		result		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END COMPONENT;

signal ALU_out    : std_logic_vector(15 downto 0);
signal Reg_W_data : std_logic_vector(15 downto 0);
signal Rp_data    : std_logic_vector(15 downto 0);
signal Rq_data    : std_logic_vector(15 downto 0);



begin

mux : mux1 port map(ALU_out,R_data,RF_s,Reg_W_data);

bank : register_bank port map(Rp_data,Rq_data,Reg_W_data,RF_W_addr,RF_Rp_addr,RF_Rq_addr,RF_W_wr,RF_Rp_rd,RF_Rq_rd,clk,'1');

ari : ALU port map(Rp_data,Rq_data,alu_s0,ALU_out);

RAM_W_data <= Rp_data;

end ckt;