LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity FIFOM is 
	port(
	clkM, wr, rd, clrfifo, clrcnt, ldcnt :  in std_logic;
	emo,fuo										 : out std_logic;
 	hex0,hex1,hex2,hex3,hex4,hex5        : out std_logic_vector(6 downto 0);
	test1   : OUT STD_LOGIC_VECTOR (12 DOWNTO 0)
	
	);
end FIFOM;

architecture ckt of FIFOM is

signal rdatao,wdatain : std_logic_vector(12 downto 0);
signal addressCount   : std_logic_vector(5 downto 0);
signal disp1, disp2, disp3, disp4, disp5, disp6 : std_logic_vector(3 downto 0);
signal clkSM,clkROM   : std_logic;


component FIFO is 
	port(
	wr,rd,clk,clr 	: in  std_logic;
	rdata 			: out std_logic_vector(12 downto 0);
	wdata 			: in  std_logic_vector(12 downto 0);
	em,fu			 	: out  std_logic
	);
end component;

component DIV2 is
    port (clk_in            : in  std_logic ;
          clk_out1,clk_out2 : out std_logic );
end component;


component BIN_BCD is 
	port (	SW: IN std_logic_vector(7 downto 0);
		bcd: OUT std_logic_vector(11 downto 0)
		);

end component;

component seg7 is
 port( A: in std_logic_vector(3 downto 0);
	SD: out std_logic_vector(6 downto 0));
end component;

component rom IS
	PORT(
		address		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (12 DOWNTO 0)
	);
END component;

component counterROM IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		cnt_en		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
	);
END component;


begin

clkDiv : DIV2 port map(
	clk_in   =>   clkM,
   clk_out1 =>  clkSM,
	clk_out2 => CLKROM
);

fifo1 : FIFO port map(
	wr    =>      wr,
	rd    =>      rd,
	clk   =>    clkSM,
	clr   => clrfifo,
	rdata =>  rdatao,			
	wdata => wdatain,
	em    =>     emo,
	fu		=>	 	 fuo
);

rom1 : ROM port map(
	address => addressCount,
	clock   =>       clkROM,
	q       =>      wdatain
);
contador : counterROM port map(
	clock	  =>   clkROM,
	cnt_en  => ldcnt,
	q       => addressCount

);

bin_bcd1: BIN_BCD port map(
	SW (7 downto 6) =>         "00",
	SW( 5 downto 0) => addressCount,	
	bcd(3 downto 0) =>        disp1,
	bcd(7 downto 4) =>        disp2
);

bin_bcd2: BIN_BCD port map(
	SW              => rdatao(7 downto 0),
	bcd(3 downto 0) =>        disp3,
	bcd(7 downto 4) =>        disp4
);

displ4 : seg7 port map(disp1,hex4);

displ5 : seg7 port map(disp2,hex5);

displ0 : seg7 port map(disp3,hex0);

displ1 : seg7 port map(disp4,hex1);

displ2 : seg7 port map("0000",hex2);

displ3 : seg7 port map("0000",hex3);


test1  <= wdatain;
---test2  <= clkROM;

end ckt;