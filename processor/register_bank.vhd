LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity register_bank is 
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
end register_bank;
	
ARCHITECTURE ckt OF register_bank IS
type reg_arr is array(0 to 3) of std_logic_vector(7 downto 0);
signal data : reg_arr;
signal addr_w : integer;
signal addr_rp : integer;
signal addr_rq : integer;
begin
	R_WProc: process(clk,data,BRz,Reg,RegX,W_wr,addr_w,addr_rp,addr_rq) is
	begin
	
		addr_w <= to_integer(unsigned(Reg));
		addr_rp <= to_integer(unsigned(Reg));
		addr_rq <= to_integer(unsigned(RegX));
		
		if rising_edge(clk) then
			if (clr = '0')then
				data <= (others => (others =>'0'));end if;
					
			
			BRy <= data(addr_rp);
			BRx <= data(addr_rq);
			
			if (W_wr = '1')then	
					data(addr_w) <= BRz;end if;
				
			
		end if;
			
			
	end process;
	
end ckt;