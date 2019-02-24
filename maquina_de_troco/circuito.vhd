LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity circuito is
    port( V : in std_logic_vector(9 downto 0);
			 bs, clk, c5, c4, c3, c2, c1, c0,r    : in std_logic;
			 led1, led2, i5, i4, i3, i2, i1, i0 : out std_logic
	 );
	 
end circuito;

architecture ckt of circuito is

component counter is
	port(
		clock, CLR, inc: in std_logic;
		S: out std_logic_vector(3 downto 0)
	);
end component;

component mini_rom IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
	);
END component;

component mux1 IS
	PORT
	(
		data0x		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		data1x		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		sel		: IN STD_LOGIC ;
		result		: OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
	);
END component;

component reg10 IS
	PORT ( D : IN STD_LOGIC_VECTOR(9 DOWNTO 0) ;
			 Resetn, Clock,ld: IN STD_LOGIC ;
			 Q : OUT STD_LOGIC_VECTOR(9 DOWNTO 0) ) ;
END component ;

component sub IS
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
	);
END component;

component mux2 IS
	PORT
	(
		data0		: IN STD_LOGIC ;
		data1		: IN STD_LOGIC ;
		data2		: IN STD_LOGIC ;
		data3		: IN STD_LOGIC ;
		data4		: IN STD_LOGIC ;
		data5		: IN STD_LOGIC ;
		sel		: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		result		: OUT STD_LOGIC 
	);
END component;

component smaller IS
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		alb		: OUT STD_LOGIC 
	);
END component;

component equal IS
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		aeb		: OUT STD_LOGIC 
	);
END component;

component equal2 IS
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		aeb		: OUT STD_LOGIC 
	);
END component;

component dec IS
	PORT
	(
		data		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		enable		: IN STD_LOGIC ;
		eq0		: OUT STD_LOGIC ;
		eq1		: OUT STD_LOGIC ;
		eq2		: OUT STD_LOGIC ;
		eq3		: OUT STD_LOGIC ;
		eq4		: OUT STD_LOGIC ;
		eq5		: OUT STD_LOGIC 
	);
END component;

signal clr_p, clk_p, sel1, ld_tot, 
			c_de_p,totLTcoin,tot_eq_0, p_eq_5, enable_read: std_logic;
			
signal p : std_logic_vector(3 downto 0);
signal tot_sub_coin, muxTot, coin, tot : std_logic_vector(9 downto 0);

type state_type is (S, cal, subt, ppp, B, F);
signal y_present : state_type := S;
signal y_next    : state_type := S;



begin
	regestado: process(clk, r)
	begin
		if r = '1'  then 
			y_present <= S;
		elsif (clk'event and clk = '1') then
			y_present <= y_next;
		end if;
	end process;
	
	logicacomb: process(y_present, totLTcoin, c_de_p, p_eq_5, tot_eq_0, bs)
	begin
		ld_tot <= '0';
		clr_p  <= '1';
		led1   <= '0';
		led2   <= '0';
		sel1   <= '0';
		clk_p  <= '0';
		enable_read <= '0';
		case y_present is
			when S =>
				ld_tot <= '1';
				clr_p  <= '0';
				sel1   <= '1';
				if bs = '1' then
					y_next <= cal;
				else 
					y_next <= S; end if;
			
			when cal =>
				--ld_tot <= '0';
				--sel    <= '0';
				clk_p  <= '0';
				led1   <= '1';
				if (totLTcoin = '1') then
					if tot_eq_0 = '1'  then
						y_next <= B;
					elsif p_eq_5 = '0' then
						y_next <= ppp;
					else
						y_next <= F;
					end if;
				else
					if c_de_p = '1' then 
						y_next <= subt;
					else
						y_next <= ppp;
					end if;
				end if;
			
			when subt =>
				ld_tot <= '1';
				y_next <= cal;
				led1   <= '1';
				enable_read <= '1';

			
			when ppp =>
				clk_p  <= '1';
				y_next <= cal;
				led1   <= '1';
				
				
			when B =>
				led1 <= '0';
				led2 <= '0';
			
			when F =>
				led1   <= '0';
				led2   <= '1';	
		end case;	
	end process;
	
	
	cont_p : counter   port map(clk_p, clr_p, '1', p);

	romzin : mini_rom port map(p(2 downto 0), clk, coin);

	priMux : mux1 port map(tot_sub_coin, V, sel1, muxTot);

	reg : reg10 port map(MuxTot, '1', clk, ld_tot, tot);

	sub1 : sub port map(tot, coin, tot_sub_coin);

	segMux : mux2 port map(c0, c1, c2, c3, c4, c5, p(2 DOWNTO 0),c_de_p);

	less1 : smaller port map(tot, coin, totLTcoin);

	equal1 : equal port map(tot,tot_eq_0);

	secequal2 : equal2 port map(p, p_eq_5);
	
	dec1 : dec port map(p,enable_read,i0,i1,i2,i3,i4,i5);

	


end ckt;