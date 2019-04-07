LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY control_block IS
	PORT
	(
		r,clk : in std_logic;
		Wa,clk_d    : OUT STD_LOGIC;
		
		count_PC  : OUT STD_LOGIC;						 --PC
		sel_PC : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); --PC	
		
		count_SP  : OUT STD_LOGIC;                  --SP
		push_pop  : OUT STD_LOGIC;						 --SP
		sel_SP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); --SP
		out_SP    :  IN STD_LOGIC_VECTOR (7 DOWNTO 0); --SP
		
		OP_sel   : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); -- ULA
				
		AB_Reg      : OUT  std_logic_vector(1  downto 0); --ABCD
		AB_RegX     : OUT  std_logic_vector(1  downto 0); --ABCD
		W_wr        : OUT  std_logic;                     --ABCD		
	
		op_out : IN std_LOGIC_VECTOR(7 downto 0);    -- OPCODE Register
		op_ld  : OUT STD_LOGIC;                       -- OPCODE Register
		
		op1_out : IN std_LOGIC_VECTOR(7 downto 0);    -- OPERAND 2 Register
		op1_ld  : OUT STD_LOGIC;                       -- OPERAND 1 Register
		op2_out : IN std_LOGIC_VECTOR(7 downto 0);    -- OPERAND 2 Register
		op2_ld  : OUT STD_LOGIC;                       -- OPERAND 2 Register	

		const   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		const2  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				
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



type state is (start,search,search2,decoding,JMP2,STK3,STK4,STK5,MOV,ADD,ADD2,ADD3,INC,CMP,JMP,HLT,OPR,OPR_1,OPR_2,RET,OPR2,ERRO,EXE,MOV2,MOV3,STK,STK2);
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
				elsif (op_out >= X"0A" AND op_out <= X"17") then y_next <= ADD; -- >= 10 <= 23
				elsif (op_out >= X"1E" AND op_out <= X"2B") then y_next <= JMP; -- >= 30 <= 43
				elsif (op_out >= X"32" AND op_out <= X"39") then y_next <= STK; -- >= 50 <= 57
				elsif (op_out >= X"3C" AND op_out <= X"61") then y_next <= ADD; -- >= 60 <= 97
				else y_next <= ERRO;
				end if;
			
			when MOV =>
				y_next <= MOV2;
				
			when MOV3 =>
				y_next <= start;

			when MOV2 =>
				if (op_out >= X"05" AND op_out <= X"08") then
					y_next <= MOV3;
				else 
					y_next <= start;
				end if;
				
			when ADD =>
				y_next <= ADD2;
			
			when ADD2 =>
				y_next <= ADD3;
			
			when ADD3 =>
				y_next <= start;
			
			when STK =>
				y_next <= STK2;
				
			when STK2 =>
				y_next <= STK3;
			when STK3 =>
				y_next <= STK4;
			when STK4 =>
				y_next <= STK5;
			when STK5 =>
					y_next <= start;
			
			when JMP =>
				y_next <= JMP2;
				
			when JMP2 =>
				y_next <= start;
			
			
			when OTHERS =>
				y_next <= start;
		end case;
	end process;
	
	process(y_present,op_out,op1_out,op2_out,out_SP)
	begin
		count_PC <= '0';
		sel_PC <= "01"; 
		count_SP <= '0';
		push_pop <= '0';
		sel_SP <= "00";
		 
		OP_sel <= "0000";
		clk_d <= '0';
		AB_Reg <= "00";  
		AB_RegX <= "00"; 
		W_wr <= '0'	;    
		--op_out <= X"00";
		op_ld  <= '0';
		--	<= X"00";
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
				
			when JMP =>
				if (op_out = x"1E") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					
			
			when STK =>
			
				--PUSH
				if (op_out = x"32") then
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM	<= "011";
					count_SP <= '1';
					if(out_SP = X"00") then
						sel_SP <= "00";
					else
						sel_SP <= "01";end if;
				
				elsif (op_out = x"33") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM	<= "010";
					count_SP <= '1';
					if(out_SP = X"00") then
						sel_SP <= "00";
					else
						sel_SP <= "01";end if;
						
				elsif (op_out = x"34") then
					const <= op2_out;
					sel_MUX_MEM <= "100";
					count_SP <= '1';
					if(out_SP = X"00") then
						sel_SP <= "00";
					else
						sel_SP <= "01";end if;
						
				elsif (op_out = x"35") then
					const <= op2_out;
					sel_MUX_MEM <= "011";
					count_SP <= '1';
					if(out_SP = X"00") then
						sel_SP <= "00";
					else
						sel_SP <= "01";end if;
				--POP
				elsif (op_out = x"36") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM <= "011";
					count_SP <= '1';
					push_pop <= '1';
					if(out_SP = X"00") then
						sel_SP <= "00";
					else
						sel_SP <= "01";end if;
				
				--CALL
				elsif (op_out = x"37") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM <= "011";
					sel_MUX_Da <= "11";
					count_SP <= '1';
					--push_pop <= '1';
					if(out_SP = X"00") then
						sel_SP <= "00";
					else
						sel_SP <= "01";end if;
				elsif (op_out = x"38") then
					const <= op2_out;
					sel_MUX_MEM <= "011";
					sel_MUX_Da <= "11";
					count_SP <= '1';
					--push_pop <= '1';
					if(out_SP = X"00") then
						sel_SP <= "00";
					else
						sel_SP <= "01";end if;
				
					
				end if;
				
			when STK2 =>
			
				--PUSH
				if (op_out = x"32") then
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM <= "011";
					Wa <= '1';
				elsif (op_out = x"33") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM	<= "010";
					sel_MUX_Da <= "01";
					--Wa <= '1';
					
				elsif (op_out = x"34") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM	<= "011";
					sel_MUX_Da <= "01";
					Wa <= '1';
					
				elsif (op_out = x"35") then
					const <= op2_out;
					sel_MUX_MEM	<= "011";
					sel_MUX_Da <= "10";
					Wa <= '1';
				
				--POP
				elsif (op_out = x"36") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM <= "011";
					W_wr <= '1';
				
				--CALL
				elsif (op_out = x"37") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM	<= "011";
					sel_MUX_Da <= "11";
					Wa <= '1';
				elsif (op_out = x"38") then
					const <= op2_out;
					sel_MUX_MEM	<= "011";
					sel_MUX_Da <= "11";
					Wa <= '1';
					
				
				end if;
				
			when STK3 =>
			
				--PUSH
				if (op_out = x"33") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM	<= "011";
					sel_MUX_Da <= "01";
					Wa <= '1';
				--CALL
				elsif (op_out = x"37") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM	<= "010";
					
				elsif (op_out = x"38") then
					const <= op2_out;
					sel_MUX_MEM	<= "100";
					sel_PC <= "10";
					count_PC <= '1';
			
				
				end if;
				
			when STK4 =>
				--CALL
				if (op_out = x"37") then
					count_PC <= '1';
					sel_PC <= "00";
					
				elsif (op_out = x"38") then	
					--count_PC <= '1';
					--sel_PC <= "00";

				
				end if;
			
	
	
			when ADD =>
				--ADICAO
				if (op_out = x"0A") then	
					AB_Reg <= op1_out(1 DOWNTO 0);
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
				
				elsif (op_out = x"0B") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
				
				elsif (op_out = x"0C") then
					const <= op2_out;
					sel_MUX_MEM <= "100";
					AB_Reg <= op1_out(1 DOWNTO 0);
					
				elsif (op_out = x"0D") then
					const <= op2_out;
					sel_MUX_ULA <= "10";
					AB_Reg <= op1_out(1 DOWNTO 0);
				
				--SUBTRAÇAO
				elsif (op_out = x"0E") then	
					AB_Reg <=op1_out(1 DOWNTO 0);
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					OP_sel <= "0001";
				
				elsif (op_out = x"0F") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					OP_sel <= "0001";
				
				elsif (op_out = x"10") then
					const <= op2_out;
					sel_MUX_MEM <= "100";
					AB_Reg <=op1_out(1 DOWNTO 0);
					OP_sel <= "0001";
					
				elsif (op_out = x"11") then
					const <= op2_out;
					sel_MUX_ULA <= "10";
					AB_Reg <=op1_out(1 DOWNTO 0);
					OP_sel <= "0001";
				
				--INCREMENT
				elsif (op_out = x"12") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					OP_sel <= "0011";
					
				elsif (op_out = x"13") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					OP_sel <= "0100";
				
				--COMPARE
				
				elsif (op_out = x"14") then	
					AB_Reg <=op1_out(1 DOWNTO 0);
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					OP_sel <= "1011";
					
				elsif (op_out = x"15") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					OP_sel <= "1011";
				
				elsif (op_out = x"16") then
					const <= op2_out;
					sel_MUX_MEM <= "100";
					AB_Reg <=op1_out(1 DOWNTO 0);
					OP_sel <= "1011";
					
				elsif (op_out = x"17") then
					const <= op2_out;
					sel_MUX_ULA <= "10";
					AB_Reg <=op1_out(1 DOWNTO 0);
					OP_sel <= "1011";
				
				-- MUTIPLICACAO
				
				elsif (op_out = x"3C") then	
					AB_Reg <= "00";
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					OP_sel <= "0010";
				
				elsif (op_out = x"3D") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					OP_sel <= "0010";
				
				elsif (op_out = x"3E") then
					const <= op2_out;
					sel_MUX_MEM <= "100";
					AB_Reg <= "00";
					OP_sel <= "0010";
					
				elsif (op_out = x"3F") then
					const <= op2_out;
					sel_MUX_ULA <= "10";
					AB_Reg <= "00";
					OP_sel <= "0010";
				
				--AND
				
				elsif (op_out = x"46") then	
					AB_Reg <=op1_out(1 DOWNTO 0);
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					OP_sel <= "0101";
				
				elsif (op_out = x"47") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					OP_sel <= "0101";
				
				elsif (op_out = x"48") then
					const <= op2_out;
					sel_MUX_MEM <= "100";
					AB_Reg <=op1_out(1 DOWNTO 0);
					OP_sel <= "0101";
					
				elsif (op_out = x"49") then
					const <= op2_out;
					sel_MUX_ULA <= "10";
					AB_Reg <=op1_out(1 DOWNTO 0);
					OP_sel <= "0101";
					
				--OR
				
				elsif (op_out = x"4A") then	
					AB_Reg <=op1_out(1 DOWNTO 0);
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					OP_sel <= "0110";
				
				elsif (op_out = x"4B") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					OP_sel <= "0110";
				
				elsif (op_out = x"4C") then
					const <= op2_out;
					sel_MUX_MEM <= "100";
					AB_Reg <=op1_out(1 DOWNTO 0);
					OP_sel <= "0110";
					
				elsif (op_out = x"4D") then
					const <= op2_out;
					sel_MUX_ULA <= "10";
					AB_Reg <=op1_out(1 DOWNTO 0);
					OP_sel <= "0110";
					
				--XOR
				
				elsif (op_out = x"4E") then	
					AB_Reg <=op1_out(1 DOWNTO 0);
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					OP_sel <= "0111";
				
				elsif (op_out = x"4F") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					OP_sel <= "0111";
				
				elsif (op_out = x"50") then
					const <= op2_out;
					sel_MUX_MEM <= "100";
					AB_Reg <=op1_out(1 DOWNTO 0);
					OP_sel <= "0111";
					
				elsif (op_out = x"51") then
					const <= op2_out;
					sel_MUX_ULA <= "10";
					AB_Reg <=op1_out(1 DOWNTO 0);
					OP_sel <= "0111";
					
				--SHL
				
				elsif (op_out = x"5A") then	
					AB_Reg <=op1_out(1 DOWNTO 0);
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					OP_sel <= "1001";
				
				elsif (op_out = x"5B") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					OP_sel <= "1001";
				
				elsif (op_out = x"5C") then
					const <= op2_out;
					sel_MUX_MEM <= "100";
					AB_Reg <=op1_out(1 DOWNTO 0);
					OP_sel <= "1001";
					
				elsif (op_out = x"5D") then
					const <= op2_out;
					sel_MUX_ULA <= "10";
					AB_Reg <=op1_out(1 DOWNTO 0);
					OP_sel <= "1001";
				
				--SHR
				
				elsif (op_out = x"5E") then	
					AB_Reg <=op1_out(1 DOWNTO 0);
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					OP_sel <= "1010";
				
				elsif (op_out = x"5F") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					OP_sel <= "1010";
				
				elsif (op_out = x"60") then
					const <= op2_out;
					sel_MUX_MEM <= "100";
					AB_Reg <=op1_out(1 DOWNTO 0);
					OP_sel <= "1010";
					
				elsif (op_out = x"61") then
					const <= op2_out;
					sel_MUX_ULA <= "10";
					AB_Reg <=op1_out(1 DOWNTO 0);
					OP_sel <= "1010";
				
				
				end if;
			
			when ADD2 =>
				--ADDING
				if (op_out = x"0A") then	
					AB_Reg <=op1_out(1 DOWNTO 0);
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					
				elsif (op_out = x"0B") then
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					sel_MUX_ULA <= "01";
					--W_wr <= '1';
					
				elsif (op_out = x"0C") then
					--const <= op2_out(1 DOWNTO 0);
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ULA <= "01";
					sel_MUX_MEM <= "001";
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					
				elsif (op_out = x"0D") then
					const <= op2_out;
					sel_MUX_ULA <= "10";
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					
				--SUBTRACTING
				elsif (op_out = x"0E") then	
					AB_Reg <=op1_out(1 DOWNTO 0);
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					OP_sel <= "0001";
					
				elsif (op_out = x"0F") then
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					sel_MUX_ULA <= "01";
					OP_sel <= "0001";
					clk_d <= '1';
					--W_wr <= '1';
					
				elsif (op_out = x"10") then
					--const <= op2_out(1 DOWNTO 0);
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ULA <= "01";
					sel_MUX_MEM <= "001";
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					OP_sel <= "0001";
					
				elsif (op_out = x"11") then
					const <= op2_out;
					sel_MUX_ULA <= "10";
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					OP_sel <= "0001";
					
				--INCREMENT
				elsif (op_out = x"12") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					OP_sel <= "0011";
					W_wr <= '1';
					clk_d <= '1';
					
				elsif (op_out = x"13") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					OP_sel <= "0100";
					W_wr <= '1';
					clk_d <= '1';
				
				--COMPARE
				elsif (op_out = x"14") then	
					AB_Reg <=op1_out(1 DOWNTO 0);
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					OP_sel <= "1011";
					clk_d <= '1';
					
				elsif (op_out = x"15") then
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					sel_MUX_ULA <= "01";
					OP_sel <= "1011";
					--W_wr <= '1';
					--clk_d <= '1';
					
				elsif (op_out = x"16") then
					--const <= op2_out(1 DOWNTO 0);
					AB_Reg <= op1_out(1 DOWNTO 0);
					sel_MUX_ULA <= "01";
					sel_MUX_MEM <= "001";
					--W_wr <= '1';
					--clk_d <= '1';
					OP_sel <= "1011";
					clk_d <= '1';
					
				elsif (op_out = x"17") then
					const <= op2_out;
					sel_MUX_ULA <= "10";
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					OP_sel <= "1011";
				
				--MULTIPLICACAO
				
				elsif (op_out = x"3C") then	
					AB_Reg <="00";
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					OP_sel <= "0010";
					W_wr <= '1';
					clk_d <= '1';
					
				elsif (op_out = x"3D") then
					AB_Reg <="00";
					sel_MUX_MEM <= "010";
					sel_MUX_ULA <= "01";
					OP_sel <= "0010";
					--W_wr <= '1';
					
				elsif (op_out = x"3E") then
					--const <= op2_out(1 DOWNTO 0);
					AB_Reg <="00";
					sel_MUX_ULA <= "01";
					sel_MUX_MEM <= "001";
					sel_MUX_ABCD_IN <= "01";
					OP_sel <= "0010";
					W_wr <= '1';
					clk_d <= '1';
					
				elsif (op_out = x"3F") then
					const <= op2_out;
					sel_MUX_ULA <= "10";
					AB_Reg <="00";
					sel_MUX_ABCD_IN <= "01";
					OP_sel <= "0010";
					W_wr <= '1';
					clk_d <= '1';
					
				--AND
				
				elsif (op_out = x"46") then	
					AB_Reg <=op1_out(1 DOWNTO 0);
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					OP_sel <= "0101";
					
				elsif (op_out = x"47") then
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					sel_MUX_ULA <= "01";
					OP_sel <= "0101";
					clk_d <= '1';
					--W_wr <= '1';
					
				elsif (op_out = x"48") then
					--const <= op2_out(1 DOWNTO 0);
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ULA <= "01";
					sel_MUX_MEM <= "001";
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					OP_sel <= "0101";
					
				elsif (op_out = x"49") then
					const <= op2_out;
					sel_MUX_ULA <= "10";
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					OP_sel <= "0101";
					
				--OR
				
				elsif (op_out = x"4A") then	
					AB_Reg <=op1_out(1 DOWNTO 0);
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					OP_sel <= "0110";
					
				elsif (op_out = x"4B") then
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					sel_MUX_ULA <= "01";
					OP_sel <= "0110";
					clk_d <= '1';
					--W_wr <= '1';
					
				elsif (op_out = x"4C") then
					--const <= op2_out(1 DOWNTO 0);
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ULA <= "01";
					sel_MUX_MEM <= "001";
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					OP_sel <= "0110";
					
				elsif (op_out = x"4D") then
					const <= op2_out;
					sel_MUX_ULA <= "10";
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					OP_sel <= "0110";
					
				--XOR
				
				elsif (op_out = x"4E") then	
					AB_Reg <=op1_out(1 DOWNTO 0);
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					OP_sel <= "0111";
					
				elsif (op_out = x"4F") then
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					sel_MUX_ULA <= "01";
					OP_sel <= "0111";
					clk_d <= '1';
					--W_wr <= '1';
					
				elsif (op_out = x"50") then
					--const <= op2_out(1 DOWNTO 0);
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ULA <= "01";
					sel_MUX_MEM <= "001";
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					OP_sel <= "0111";
					
				elsif (op_out = x"51") then
					const <= op2_out;
					sel_MUX_ULA <= "10";
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					OP_sel <= "0111";
					
				--SHL
				
				elsif (op_out = x"5A") then	
					AB_Reg <=op1_out(1 DOWNTO 0);
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					OP_sel <= "1001";
					
				elsif (op_out = x"5B") then
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					sel_MUX_ULA <= "01";
					OP_sel <= "1001";
					clk_d <= '1';
					--W_wr <= '1';
					
				elsif (op_out = x"5C") then
					--const <= op2_out(1 DOWNTO 0);
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ULA <= "01";
					sel_MUX_MEM <= "001";
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					OP_sel <= "1001";
					
				elsif (op_out = x"5D") then
					const <= op2_out;
					sel_MUX_ULA <= "10";
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					OP_sel <= "1001";
					
				--SHR
				
				elsif (op_out = x"5E") then	
					AB_Reg <=op1_out(1 DOWNTO 0);
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					OP_sel <= "1010";
					
				elsif (op_out = x"5F") then
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					sel_MUX_ULA <= "01";
					OP_sel <= "1010";
					clk_d <= '1';
					--W_wr <= '1';
					
				elsif (op_out = x"60") then
					--const <= op2_out(1 DOWNTO 0);
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ULA <= "01";
					sel_MUX_MEM <= "001";
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					OP_sel <= "1010";
					
				elsif (op_out = x"61") then
					const <= op2_out;
					sel_MUX_ULA <= "10";
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					W_wr <= '1';
					clk_d <= '1';
					OP_sel <= "1010";
				
			
					
				end if;
				
				
				
			when ADD3 =>
				if (op_out = x"0B") then
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					sel_MUX_ULA <= "01";
					W_wr <= '1';
					clk_d <= '1';
					
				elsif (op_out = x"0F") then
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					sel_MUX_ULA <= "01";
					OP_sel <= "0001";
					W_wr <= '1';
					clk_d <= '1';
					
				elsif (op_out = x"15") then
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					sel_MUX_ULA <= "01";
					--OP_sel <= "0001";
					clk_d <= '1';
					OP_sel <= "1011";
					
				elsif (op_out = x"3D") then
					AB_Reg <="00";
					sel_MUX_ABCD_IN <= "01";
					sel_MUX_ULA <= "01";
					--OP_sel <= "0001";
					clk_d <= '1';
					W_wr <= '1';
					OP_sel <= "0010";
					
				elsif (op_out = x"47") then
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					sel_MUX_ULA <= "01";
					OP_sel <= "0101";
					W_wr <= '1';
					clk_d <= '1';
					
				elsif (op_out = x"4B") then
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					sel_MUX_ULA <= "01";
					OP_sel <= "0110";
					W_wr <= '1';
					clk_d <= '1';
				
				elsif (op_out = x"4F") then
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					sel_MUX_ULA <= "01";
					OP_sel <= "0111";
					W_wr <= '1';
					clk_d <= '1';
					
				elsif (op_out = x"5B") then
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					sel_MUX_ULA <= "01";
					OP_sel <= "1001";
					W_wr <= '1';
					clk_d <= '1';
					
				elsif (op_out = x"5F") then
					AB_Reg <=op1_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN <= "01";
					sel_MUX_ULA <= "01";
					OP_sel <= "1010";
					W_wr <= '1';
					clk_d <= '1';

	
				end if;
			
			

			
			when MOV =>
				--define todas a variaveis padrao
				if (op_out = x"01") then
					AB_Reg <=op1_out(1 DOWNTO 0);  
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN<= "10"; 
					W_wr <= '1'	;  
					
				elsif (op_out = x"02") then
					sel_MUX_MEM <= "100";
					const <= op2_out;
					AB_Reg <=op1_out(1 DOWNTO 0);
				
				elsif (op_out = x"03") then
					AB_Reg <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					
				elsif (op_out = x"04") then
					sel_MUX_ABCD_IN <= "11";
					const <= op2_out;
					AB_reg <=op1_out(1 DOWNTO 0);
					
				elsif (op_out = x"05") then
					AB_Reg  <=op1_out(1 DOWNTO 0);
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_MEM <= "010";
					--Wa <= '1';
				
				elsif (op_out = x"06") then
					AB_Reg  <=op1_out(1 DOWNTO 0);
					sel_MUX_Da <= "10";
					sel_MUX_MEM <= "010";
					const <= op2_out;
				
				elsif (op_out = x"07") then
				   AB_Regx  <= op2_out(1 DOWNTO 0);
					const <= op1_out;
					sel_MUX_MEM <= "100";
					--Wa <= '1';
				else
					sel_MUX_Da <= "10";
					sel_MUX_MEM <= "101";
					const <= op2_out;
					const2 <=op1_out;
					
				end if;

			when MOV2 =>
				--define todas a variaveis padrao
				if (op_out = x"01") then
					AB_Reg <=op1_out(1 DOWNTO 0);  
					AB_RegX <= op2_out(1 DOWNTO 0);
					sel_MUX_ABCD_IN<= "10"; 
					W_wr <= '1'	;
					 					
				elsif (op_out = x"02") then
					--sel_MUX_MEM <= "111";
					const <= op2_out;
					AB_Reg <=op1_out(1 DOWNTO 0);
					W_wr <= '1'	;
					
				elsif (op_out = x"03") then
					AB_Reg <=op1_out(1 DOWNTO 0);
					--sel_MUX_MEM <= "010";
					W_wr <= '1';
					clk_d <= '1';
					
				elsif (op_out = x"04") then
					sel_MUX_ABCD_IN <= "11";
					const <= op2_out;
					AB_reg <=op1_out(1 DOWNTO 0);
					W_wr <= '1';
					clk_d <= '1';

				elsif (op_out = x"05") then
					sel_MUX_MEM <= "010";
					Wa <= '1';
				
				elsif (op_out = x"06") then
				   --AB_Reg  <= 	(1 DOWNTO 0);
					const <= op2_out;
					sel_MUX_Da <= "10";
					sel_MUX_MEM <= "010";
					Wa <= '1';
					
				elsif (op_out = x"07") then
				   AB_Regx  <= op2_out(1 DOWNTO 0);
					const <=op1_out;
					sel_MUX_MEM <= "100";
					Wa <= '1';
				
				else 
					sel_MUX_Da <= "10";
					sel_MUX_MEM <= "101";
					const <= op2_out;
					const2 <=op1_out;
					Wa <= '1';

				end if;
				
			
			
			
				
			when OTHERS => 
				
					
					
		end case;
	end process;

end ckt; 

