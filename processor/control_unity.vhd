LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY control_unity IS
	PORT
	(
		r,clk : in std_logic;
	
	addr : out std_logic_vector(7 downto 0);
	data : in std_logic_vector(15 downto 0);
	I_rd : out std_logic;
	
	RF_s,RF_W_wr,RF_Rp_rd,RF_Rq_rd,alu_s0,D_rd,D_wr       : out std_logic;
	RF_W_addr,RF_Rp_addr,RF_Rq_addr                       : out std_logic_vector(3 downto 0);
	D_addr : out std_logic_vector(7 downto 0)
	);
END control_unity;

ARCHITECTURE ckt OF control_unity IS
begin


END ckt;
