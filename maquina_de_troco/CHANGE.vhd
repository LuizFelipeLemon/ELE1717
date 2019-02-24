LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity CHANGE is
    port( clkM, bns, clr_count : in std_logic;
			 hex0,hex1,hex2       : out std_logic_vector(6 downto 0);
			 clkout, led1, led2   : out std_logic := '0';
			 addro		: out STD_LOGIC_VECTOR (3 DOWNTO 0);
			 o,a,b,c,d,e : out std_logic
	 );
	 
end CHANGE;

architecture ckt of CHANGE is 

component circuito is
    port( V : in std_logic_vector(9 downto 0);
			 bs, clk, c5, c4, c3, c2, c1, c0,r    : in std_logic;
			 led1, led2, i5, i4, i3, i2, i1, i0 : out std_logic
	 );
	 
end component;

component cofre is 
	port(i, clk : in  std_logic;
		  c     : out std_logic
			);
	
end component;

component CLK_Div is
    port (clk_in            : in  std_logic ;
          clk_out : out std_logic );
end component;

component ROM IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
	);
END component;

component counterROM IS
	PORT
	(
		aclr		: IN STD_LOGIC ;
		clk_en		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	);
end component;

component button is
    port (clk , r, bi: in std_logic ;
            bo : out std_logic);
end component ;

component BINBCD16 is
    port(  BINBCD_in: in std_logic_vector(15 downto 0) ;
            BINBCD_out : out std_logic_vector(19 downto 0) 
        );
end component ;

component seg7 is
	port(A: in std_logic_vector(3 downto 0);
		SD: out std_logic_vector(6 downto 0));
end component;


signal clk_m, bs_o: std_logic;
signal addr		: STD_LOGIC_VECTOR (3 DOWNTO 0);
signal V			: STD_LOGIC_VECTOR (9 DOWNTO 0);
signal bcdl    : STD_LOGIC_VECTOR (15 DOWNTO 0);
signal bdc_out : std_logic_vector(19 downto 0);
signal seg71,seg72,seg73		: STD_LOGIC_VECTOR (3 DOWNTO 0);


signal c5, c4, c3, c2, c1, c0 :  std_logic;
signal i5, i4, i3, i2, i1, i0 :  std_logic;

begin
	clkout <= clk_m;
	
	div : CLK_Div port map(clkM, clk_m);
	
	bs : button port map(clk_m, '0', bns, bs_o);
	
	cr : counterROM port map(not clr_count, not bs_o, clk_m, addr);
	addro <= addr;
	o<=bs_o;
	
	rum : ROM port map(addr, clk_m, V);
	
	cf0 : cofre port map(i0, clk_m, c0);
	cf1 : cofre port map(i1, clk_m, c1);
	cf2 : cofre port map(i2, clk_m, c2);
	cf3 : cofre port map(i3, clk_m, c3);
	cf4 : cofre port map(i4, clk_m, c4);
	cf5 : cofre port map(i5, clk_m, c5);
	
	a <= c0;
	b<= c1;
	c<= c2;
	d<= c3;
	e<= c4;
	
	ci : circuito port map(V, bs_o, clk_m, c5, c4, c3, c2, c1, c0, '0',
									led1, led2, i5, i4, i3, i2, i1, i0 );
									
	--bcdl <= (others => '0');
	bcdl(9 downto 0) <= V;
	
	binBCD : BINBCD16 port map(bcdl,bdc_out);
	
	seg71 <= bdc_out(3 downto 0);
	seg72 <= bdc_out(7 downto 4);
	seg73 <= bdc_out(11 downto 8);
	
	disp1 : seg7 port map(seg71,hex0);
	disp2 : seg7 port map(seg72,hex1);
	disp3 : seg7 port map(seg73,hex2);


end ckt;