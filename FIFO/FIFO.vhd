LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity FIFO is 
	port(
	wr,rd,clk,clr 	: in  std_logic;
	rdata 			: out std_logic_vector(12 downto 0);
	wdata 			: in  std_logic_vector(12 downto 0);
	em,fu,loo,loo2			 	: out  std_logic	
	);
end FIFO;

architecture ckt of FIFO is
	type state is (s,w,rd1,rd2,wr1,wr2);
	signal y_present : state := s;
	signal y_next    : state := s;
	signal lo,loin,clrCont,wrc,rdc,incf,inci,eq :  std_logic;
	signal fim,inicio	: STD_LOGIC_VECTOR (3 DOWNTO 0);
	signal full,empty:  std_logic;

	
	
	component counter is
		port(
			clock, CLR, inc: in std_logic;
			S: out std_logic_vector(3 downto 0)
		);
	end component;
	
	component register_bank is 
		port(
		rdata 		: out std_logic_vector(12 downto 0);
		wdata 		: in  std_logic_vector(12 downto 0);
		waddr,raddr : in  std_logic_vector(3  downto 0);
		wr,rd,clk,clr 	: in  std_logic
		);
	end component;
	
	component comapare IS
		PORT(
			dataa		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			datab		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			aeb		: OUT STD_LOGIC 
		);
	END component;
	
	component ffd is
    port(
         clk,d,p,c : in  std_logic;
         q         : out std_logic
        );
	end component;
	
	
begin 
	
	iniCounter :counter port map(
		clock =>     inci, 
		CLR   =>  clrCont, 
		inc   =>      '1',
		S     =>   inicio
	);
	
	
	fimCounter :counter port map(
		clock =>     incf, 
		CLR   =>  clrCont, 
		inc   =>      '1',
		S     =>      fim
	);
	
	
	equals : comapare port map(
		dataa  => inicio,
		datab	 =>    fim,	
		aeb    =>     eq
	);
	
	
	
	bank : register_bank port map(
		rdata =>  rdata,
		wdata =>  wdata,
		waddr =>    fim,
		raddr => inicio,
		wr    =>    wrc, 
		rd    =>    rdc,
		clk   =>    clk,
		clr   =>    clr 
	);
	
	
	
	D : ffd port map(
		clk => clk,
		d   => loin,
		p   => '1',
		c   => '1',
		q   => lo      
	  );

	empty <= eq and not lo;
	full <= eq and     lo;
	em <= empty;
	fu <= full;
	
	process(wr,rd,y_present)
	begin 
		case y_present is
			when s =>
				clrCont <= '1'; -- pode ser '1'
				wrc 	  <= '0';
				y_next  <=   w;
				loin    <= '0';
								
			when w =>
				loin <= lo;
				if    wr = '1'   and  full = '0'   then y_next <= wr1;
				elsif (rd = '1') and empty = '0'   then y_next <= rd1;
				else 						                   y_next <=   w;
				end if;
			
			when wr1 =>
				wrc     <= '1';
				y_next <= wr2;
			
			when wr2 =>
				wrc    <= '0';
				loin     <= '1';
				y_next <=   w;
				
			when rd1 => 
				rdc     <= '1';
				y_next <= rd2;
				
			when rd2 =>
				rdc    <= '0';
				loin     <= '0';
				y_next <=   w;
		
		end case;
	end process;
	
	process(clk)
	begin
		if rising_edge(clk) then
			y_present <= y_next ;
		end if;
	end process ;
	incf <= '1' when y_present = wr2 else '0';
	inci <= '1' when y_present = rd2 else '0';

end ckt ;
		
				
				
				
					
				
				
				
