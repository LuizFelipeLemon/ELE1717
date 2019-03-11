LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity control_block is
port(
	r,clk : in std_logic;
	PC_inc,PC_clr,IR_ld,I_rd : out std_logic;
	IR : in std_logic_vector(15 downto 0);
	RF_s,RF_W_wr,RF_Rp_rd,RF_Rq_rd,alu_s0,D_rd,D_wr       : out std_logic;
	RF_W_addr,RF_Rp_addr,RF_Rq_addr                       : out std_logic_vector(3 downto 0);
	D_addr : out std_logic_vector(7 downto 0)
);
end control_block;


architecture ckt of control_block is 

COMPONENT decode IS
	PORT
	(
		data		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		eq0		: OUT STD_LOGIC ;
		eq1		: OUT STD_LOGIC ;
		eq2		: OUT STD_LOGIC ;
		eq3		: OUT STD_LOGIC 
	);
END COMPONENT;

type state is (start,search,decoding,load1,load2,store1,store2,sum1,sum2,halt);
signal y_present: state ;
signal y_next : state:= start;

signal eq0,eq1,eq2,eq3 : std_logic;
signal opcode  : std_LOGIC_VECTOR(3 downto 0);
signal ra,rb,rc: std_LOGIC_VECTOR(3 downto 0);
signal d : std_LOGIC_VECTOR(7 downto 0);


begin
	
	opcode <= IR(15 downto 12);
	ra <= IR(11 downto 8);
	rb <= IR(7 downto 4);
	rc <= IR(3 downto 0);
	d  <= IR(7 downto 0);
	
	decoder:decode port map(opcode,eq0,eq1,eq2,eq3);
	
	regestado: process(clk, r)
	begin
		if r = '1'  then 
			y_present <= start;
		elsif (clk'event and clk = '1') then
			y_present <= y_next;
		end if;
	end process;

	process (y_present,eq0,eq1,eq2,eq3)
	begin
		case y_present is
			when start =>
				y_next <= search;
			
			when search =>
				y_next <= decoding;
			
			when decoding =>
				if    eq0 = '1' then y_next <= load1;
				elsif eq1 = '1' then y_next <= store1;
				elsif eq2 = '1' then y_next <= sum1; 
				elsif eq3 = '1' then y_next <= halt;end if;
			
			when load1 =>
				y_next <= load2;
			when load2 =>
				y_next <= search;
				--D_addr <= d;
				--D_rd <= '1';
				--RF_s <= '1';
				--RF_W_addr <= ra;
				--RF_W_wr <= '1';
			
			when store1 =>
				y_next <= store2;
			when store2 =>
				y_next <= search;
				--D_addr <= d;
				--D_wr <= '1';
				--RF_Rp_addr <= ra;
				--RF_Rp_rd <= '1';
			
			when sum1 =>
				y_next <= sum2;
			
			when sum2 =>
				y_next <= search;
			when halt =>
				y_next <= halt;
		end case;
	end process;
	
	D_addr <=  d  when (y_present = load1 or y_present = store1 or y_present = store2)  else "00000000";
	PC_clr <= '0' when y_present = start  else '1';
	PC_inc <= '1' when y_present = search else '0';
	I_rd   <= '1' when y_present = search else '0';
	IR_ld  <= '1' when y_present = search else '0';
	D_rd   <= '1' when y_present = load1   else '0';
	D_wr   <= '1' when y_present = store2  else '0';
	RF_s   <= '1' when y_present = load1 or y_present = load2    else '0';
	alu_s0 <= '1' when y_present = sum1  or y_present = sum2     else '0';
	RF_W_wr<= '1' when y_present = load2  or y_present = sum1  or y_present = sum2     else '0';
	RF_Rp_rd<='1' when y_present = store1 or y_present = sum1 or y_present = sum2     else '0';
	RF_Rq_rd<='1' when y_present = sum1  or y_present = sum2     else '0';
	RF_W_addr <= ra when y_present = load2 or y_present = sum1 or y_present = sum2 else "0000";
	RF_Rp_addr<= ra when y_present = store1 else rb when y_present = sum1 or y_present = sum2 else "0000";
	RF_Rq_addr<= rc when y_present = sum1 or y_present = sum2 else "0000";		
			

end ckt; 