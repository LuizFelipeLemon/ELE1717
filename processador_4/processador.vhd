LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY processador IS
	PORT
	(
		addr_in		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clk,r 		: IN STD_LOGIC ;
		hex0,hex1,hex2,hex3 : out std_logic_vector(6 downto 0);
		
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

COMPONENT BINBCD16 is
    port(  BINBCD_in: in std_logic_vector(15 downto 0) ;
            BINBCD_out : out std_logic_vector(19 downto 0) 
        );
end COMPONENT;

component seg7 is
	port(A: in std_logic_vector(3 downto 0);
		SD: out std_logic_vector(6 downto 0));
end component;

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

component CLK_Div is
    port (clk_in            : in  std_logic ;
          clk_out : out std_logic );
end component;


Signal rom_addr : std_LOGIC_VECTOR(7 downto 0);
signal rom_rd   : std_logic;
signal rom_data : std_logic_vector(15 downto 0);

signal R_data,RAM_W_data	:   std_logic_vector(15 downto 0);
signal I_rd :  std_logic;
signal RF_s,RF_W_wr,RF_Rp_rd,RF_Rq_rd,alu_s0,D_rd,D_wr       :  std_logic;
signal RF_W_addr,RF_Rp_addr,RF_Rq_addr                       :  std_logic_vector(3 downto 0);
signal D_addr :  std_logic_vector(7 downto 0);

signal BINBCD_out :  std_logic_vector(19 downto 0);
signal seg71,seg72,seg73,seg74		: STD_LOGIC_VECTOR (3 DOWNTO 0);
signal ram_out		: STD_LOGIC_VECTOR (15 DOWNTO 0);
signal clk_m : std_logic;



begin
	
	--Memoria de instrucao
	IM : rom port map(rom_addr,rom_rd,rom_data);
	
	--Unidade de Controle
	CU : control_unity port map(r,clk_m,rom_addr,rom_data,rom_rd,RF_s,RF_W_wr,RF_Rp_rd,
	RF_Rq_rd,alu_s0,D_rd,D_wr,RF_W_addr,RF_Rp_addr,RF_Rq_addr,D_addr);
	
	--Datapath - Bloco operacional
	BO : datapath port map(R_data,clk_m,RF_s,RF_W_wr,RF_Rp_rd,RF_Rq_rd,alu_s0,RF_W_addr,
	RF_Rp_addr,RF_Rq_addr,RAM_W_data);
	
	--Data Memory
	DM : ram port map(D_addr,addr_in,clk_m,RAM_W_data,"0000000000000000",D_wr,'0',R_data,ram_out);
	
	--BINBCD16 
	BINBDC  : BINBCD16 port map(ram_out,BINBCD_out);
	
	div : CLK_Div port map(clk, clk_m);
	
	
	seg71 <= BINBCD_out(3 downto 0);
	seg72 <= BINBCD_out(7 downto 4);
	seg73 <= BINBCD_out(11 downto 8);
	seg74 <= BINBCD_out(15 downto 12);
	
	disp1 : seg7 port map(seg71,hex0);
	disp2 : seg7 port map(seg72,hex1);
	disp3 : seg7 port map(seg73,hex2);
	disp4 : seg7 port map(seg74,hex3);
	
	
	
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