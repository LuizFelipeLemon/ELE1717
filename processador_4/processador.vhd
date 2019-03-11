LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY processador IS
	PORT
	(
		addr_in		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clk,r 		: IN STD_LOGIC ;
		ram_out		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		-- lembre de tirar o ponto e virgula
		rom_addr_t : out std_LOGIC_VECTOR(7 downto 0);
		rom_rd_t   : out std_logic;
		rom_data_t : out std_logic_vector(15 downto 0);

		R_data_t,RAM_W_data_t	: out std_logic_vector(15 downto 0);
		I_rd_t :  out std_logic;
		RF_s_t,RF_W_wr_t,RF_Rp_rd_t,RF_Rq_rd_t,alu_s0_t,D_rd_t,D_wr_t       :  out std_logic;
		RF_W_addr_t,RF_Rp_addr_t,RF_Rq_addr_t                       :  out std_logic_vector(3 downto 0);
		D_addr_t :  out std_logic_vector(7 downto 0)
		
	);
END processador;

architecture ckt of processador is 

COMPONENT control_unity is
	port
	(
		r,clk : in std_logic;
		
		addr : out std_logic_vector(7 downto 0);
		data : in std_logic_vector(15 downto 0);
		I_rd : out std_logic;
		
		RF_s,RF_W_wr,RF_Rp_rd,RF_Rq_rd,alu_s0,D_rd,D_wr       : out std_logic;
		RF_W_addr,RF_Rp_addr,RF_Rq_addr                       : out std_logic_vector(3 downto 0);
		D_addr : out std_logic_vector(7 downto 0)
	);
end COMPONENT;

COMPONENT datapath is 
	port(
		R_data	: in  std_logic_vector(15 downto 0);
		clk : in std_logic;
		RF_s,RF_W_wr,RF_Rp_rd,RF_Rq_rd,alu_s0       : in std_logic;
		RF_W_addr,RF_Rp_addr,RF_Rq_addr             : in std_logic_vector(3 downto 0);
		RAM_W_data   : out std_logic_vector(15 downto 0)

	);
end COMPONENT;

COMPONENT rom IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ram IS
	PORT
	(
		address_a		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		address_b		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data_a		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		data_b		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren_a		: IN STD_LOGIC  := '0';
		wren_b		: IN STD_LOGIC  := '0';
		q_a		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		q_b		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END COMPONENT;


Signal rom_addr : std_LOGIC_VECTOR(7 downto 0);
signal rom_rd   : std_logic;
signal rom_data : std_logic_vector(15 downto 0);

signal R_data,RAM_W_data	:   std_logic_vector(15 downto 0);
signal I_rd :  std_logic;
signal RF_s,RF_W_wr,RF_Rp_rd,RF_Rq_rd,alu_s0,D_rd,D_wr       :  std_logic;
signal RF_W_addr,RF_Rp_addr,RF_Rq_addr                       :  std_logic_vector(3 downto 0);
signal D_addr :  std_logic_vector(7 downto 0);


begin
	
	--Memoria de instrucao
	IM : rom port map(rom_addr,rom_rd,rom_data);
	
	--Unidade de Controle
	CU : control_unity port map(r,clk,rom_addr,rom_data,rom_rd,RF_s,RF_W_wr,RF_Rp_rd,
	RF_Rq_rd,alu_s0,D_rd,D_wr,RF_W_addr,RF_Rp_addr,RF_Rq_addr,D_addr);
	
	--Datapath - Bloco operacional
	BO : datapath port map(R_data,clk,RF_s,RF_W_wr,RF_Rp_rd,RF_Rq_rd,alu_s0,RF_W_addr,
	RF_Rp_addr,RF_Rq_addr,RAM_W_data);
	
	--Data Memory
	DM : ram port map(D_addr,addr_in,clk,RAM_W_data,"0000000000000000",D_wr,'0',R_data,ram_out);
	
	
	rom_addr_t <= rom_addr;
	rom_rd_t <= rom_rd;
	rom_data_t <= rom_data;
	R_data_t   <= R_data;
	RAM_W_data_t <= RAM_W_data;
	I_rd_t <= I_rd;
	RF_s_t <= RF_s;
	RF_W_wr_t <= RF_W_wr;
	RF_Rp_rd_t <= RF_Rp_rd;
	RF_Rq_rd_t <= RF_Rq_rd;
	alu_s0_t <= alu_s0;
	D_rd_t <= D_rd;
	D_wr_t <= D_wr;	
	RF_W_addr_t <= RF_W_addr;
	RF_Rp_addr_t <= RF_Rp_addr;
	RF_Rq_addr_t <= RF_Rq_addr;
	D_addr_t <= D_addr;

end  ckt;