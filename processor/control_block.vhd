LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY control_block IS
	PORT
	(
		r,clk : in std_logic;
		Wa    : OUT STD_LOGIC;
		
		count_PC  : OUT STD_LOGIC;						 --PC
		sel_PC : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); --PC	
		
		count_SP  : OUT STD_LOGIC;                  --SP
		push_pop  : OUT STD_LOGIC;						 --SP
		sel_SP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); --SP
		
		OP_sel   : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); -- ULA
				
		AB_Reg      : OUT  std_logic_vector(1  downto 0); --ABCD
		AB_RegX     : OUT  std_logic_vector(1  downto 0); --ABCD
		W_wr        : OUT  std_logic;                     --ABCD		
	
		op_out : IN std_LOGIC_VECTOR(7 downto 0);    -- OPCODE Register
		op_ld  : OUT STD_LOGIC;                       -- OPCODE Register
		op1_out : IN std_LOGIC_VECTOR(7 downto 0);    -- OPERAND 1 Register
		op1_ld  : OUT STD_LOGIC;                       -- OPERAND 1 Register
		op2_out : IN std_LOGIC_VECTOR(7 downto 0);    -- OPERAND 2 Register
		op2_ld  : OUT STD_LOGIC;                       -- OPERAND 2 Register	

		const  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		
		sel_MUX_ABCD    : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
		sel_MUX_ABCD_IN : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
		sel_MUX_Da      : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
		sel_MUX_ULA     : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXES
		sel_MUX_MEM     : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)  -- MUXES
		
	);
END control_block;

ARCHITECTURE ckt OF control_block IS


signal eq0,eq1,eq2,eq3 : std_logic;
signal opcode  : std_LOGIC_VECTOR(3 downto 0);
signal ra,rb,rc: std_LOGIC_VECTOR(3 downto 0);



type state is (start,search,search2,decoding,MOV,ADD,INC,CMP,JMP,HLT,OPR,OPR_1,OPR_2,RET,OPR2,ERRO,EXE,MOV2,MOV3);
signal y_present: state ;
signal y_next : state:= start;


begin

	regestado: process(clk, r)
	begin
		if r = '1'  then 
			y_present <= start;
		elsif (clk'event and clk = '1') then
			y_present <= y_next;
		end if;
	end process;

	process (y_present,op_out)
	begin
		case y_present is
			when start =>
				y_next <= search;
			
			when search =>
				y_next <= search2;
			
			when search2 =>
				y_next <= decoding;
			
			when decoding =>
			
				if op_out = "00000000" then y_next <= HLT;
				elsif op_out = "00111001" then y_next <= RET;
				--else y_next <= search;
				
				--2 operandos

				elsif op_out < "00001001" or                   --[1;8[
				(op_out > "00001001" and op_out < "00010010")      --]9;18[
				or (op_out > "00010011" and op_out <"00011000") or --]19;24[
				(op_out > "01000101" and op_out < "01010010") or   --]69;82[
				(op_out > "01010010" and op_out < "01100010")      --]82;98[
				then y_next <= OPR;

				--1 operandos

				elsif op_out = "00010010" or op_out = "00010011" or --[18] e [19]
				(op_out > "00011101" and op_out < "00101100") or    --]29;44[
				(op_out > "00110001" and op_out < "00111001") or    --]49;57[
				(op_out > "00111011" and op_out < "01000000") or    --]59;64[
				op_out = "01010010" -- 82
				then y_next <= OPR2;

				else y_next <= ERRO; 
				end if;
			
			when HLT =>
				y_next <= HLT;
				
			when OPR_2 =>
				if op_out < "00001001" or                      --[1;8[
				(op_out > "00001001" and op_out < "00010010")      --]9;18[
				or (op_out > "00010011" and op_out <"00011000") or --]19;24[
				(op_out > "01000101" and op_out < "01010010") or   --]69;82[
				(op_out > "01010010" and op_out < "01100010")      --]82;98[
				then y_next <= OPR2;
				else y_next <= EXE;end if;
			
			when OPR =>
				y_next <= OPR_1;

			when OPR_1 =>
				y_next <= OPR_2;
			when OPR2 =>
				y_next <= EXE;
			
			when EXE => 
			
				if    (op_out >= X"01" AND op_out <= X"08") then y_next <= MOV;
				elsif (op_out >= X"0A" AND op_out <= X"11") then y_next <= ADD; -- >= 10 <= 17
				elsif (op_out >= X"12" AND op_out <= X"13") then y_next <= INC; -- >= 18 <= 19			
				elsif (op_out >= X"14" AND op_out <= X"17") then y_next <= CMP; -- >= 20 <= 23
				elsif (op_out >= X"1E" AND op_out <= X"2B") then y_next <= JMP; -- >= 30 <= 143
				else y_next <= ERRO;
				end if;
			
			when MOV =>
				y_next <= MOV2;
				
			when MOV3 =>
				y_next <= start;

			when MOV2 =>
				if op_out = X"05" then
					y_next <= MOV3;
				else 
					y_next <= start;
				end if;
			
			when OTHERS =>
				y_next <= start;
		end case;
	end process;
	
	process(y_present)
	begin
		count_PC <= '0';
		sel_PC <= "01"; 
		count_SP <= '0';
		push_pop <= '0';
		sel_SP <= "00";
		OP_sel <= "0000";  
		AB_Reg <= "00";  
		AB_RegX <= "00"; 
		W_wr <= '0'	;    
		--op_out <= X"00";
		op_ld  <= '0';
		--op1_out<= X"00";
		op1_ld <= '0';
		--op2_out<= X"00";
		op2_ld <= '0';
		const <= X"00";
		sel_MUX_ABCD   <= "00";
		sel_MUX_ABCD_IN<= "00";
		sel_MUX_Da     <= "00";
		sel_MUX_ULA    <= "00";
		sel_MUX_MEM    <= "000";
		Wa <= '0';

		
		case y_present is

			when search =>
				op_ld  <= '1';
				count_PC  <= '1';
			
			when decoding =>
				--count_PC  <= '1';
			
			when OPR =>
				op1_ld  <= '1';
				count_PC  <= '1';
			
			when OPR2 =>
				op2_ld  <= '1';
				count_PC  <= '1';

			when MOV =>
				--define todas a variaveis padrao
				if (op_out = x"01") then
					AB_Reg <= op1_out(1 DOWNTO 0);  
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN<= "10"; 
					W_wr <= '1'	;  
					
				elsif (op_out = x"02") then
					sel_MUX_MEM <= "111";
					const <= op2_out;
					AB_Reg <= op1_out(1 DOWNTO 0);
				
				elsif (op_out = x"03") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					
				elsif (op_out = x"04") then
					sel_MUX_ABCD_IN <= "11";
					const <= op2_out;
					AB_reg <= op1_out(1 DOWNTO 0);
					
				elsif (op_out = x"05") then
					AB_Reg  <= op1_out(1 DOWNTO 0);
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					--Wa <= '1';
				
				elsif (op_out = x"06") then
				-- tanananananana
				end if;

			when MOV2 =>
				--define todas a variaveis padrao
				if (op_out = x"01") then
					AB_Reg <= op1_out(1 DOWNTO 0);  
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN<= "10"; 
					W_wr <= '1'	;
					 					
				elsif (op_out = x"02") then
					--sel_MUX_MEM <= "111";
					const <= op2_out;
					AB_Reg <= op1_out(1 DOWNTO 0);
					W_wr <= '1'	;
					
				elsif (op_out = x"03") then
					AB_Reg <= op1_out(1 DOWNTO 0);
					--sel_MUX_MEM <= "010";
					W_wr <= '1';
					
				elsif (op_out = x"04") then
					sel_MUX_ABCD_IN <= "11";
					const <= op2_out;
					AB_reg <= op1_out(1 DOWNTO 0);
					W_wr <= '1';

				elsif (op_out = x"05") then
					sel_MUX_MEM <= "010";
					Wa <= '1';
				
				elsif (op_out = x"06") then
				-- tanananananana
				end if;
				
			when OTHERS => 
				
					
					
		end case;
	end process;

end ckt; 

