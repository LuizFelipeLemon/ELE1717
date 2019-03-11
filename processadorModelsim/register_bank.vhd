LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity register_bank is 
	port(
	Rp_data,Rq_data 		: out std_logic_vector(15 downto 0);
	W_data 		: in  std_logic_vector(15 downto 0);
	W_addr,Rp_addr,Rq_addr : in  std_logic_vector(3  downto 0);
	W_wr,Rp_rd,Rq_rd,clk,clr 	: in  std_logic
	);
end register_bank;
	
ARCHITECTURE ckt OF register_bank IS
type reg_arr is array(0 to 15) of std_logic_vector(15 downto 0);
signal data : reg_arr;
begin
	R_WProc: process(clk) is
	begin
		if rising_edge(clk) then
			if(clr = '0') then
				data <= (others => (others =>'0'));end if;
			
			if(W_wr = '1') then	
				data(to_integer(unsigned(W_addr))) <= W_data;end if;
			
			if(Rp_rd = '1') then
				Rp_data <= data(to_integer(unsigned(Rp_addr)));end if;
				
			if(Rq_rd = '1') then
				Rq_data <= data(to_integer(unsigned(Rq_addr)));end if;
			
		end if;
	end process;
end ckt;