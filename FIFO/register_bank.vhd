LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity register_bank is 
	port(
	rdata 		: out std_logic_vector(12 downto 0);
	wdata 		: in  std_logic_vector(12 downto 0);
	waddr,raddr : in  std_logic_vector(3  downto 0);
	wr,rd,clk,clr 	: in  std_logic
	);
end register_bank;
	
ARCHITECTURE ckt OF register_bank IS
type reg_arr is array(0 to 15) of std_logic_vector(12 downto 0);
signal data : reg_arr;
begin
	R_WProc: process(clk) is
	begin
		if rising_edge(clk) then
			if(clr = '0') then
				data <= (others => (others =>'0'));
			
			elsif(wr = '1') then	
				data(to_integer(unsigned(waddr))) <= wdata;
			
			elsif(rd = '1') then
				rdata <= data(to_integer(unsigned(raddr)));
			
			end if;
		end if;
	end process;
end ckt;