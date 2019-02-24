LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
ENTITY reg10 IS
	PORT ( D : IN STD_LOGIC_VECTOR(9 DOWNTO 0) ;
			 Resetn, Clock,ld: IN STD_LOGIC ;
			 Q : OUT STD_LOGIC_VECTOR(9 DOWNTO 0) ) ;
END reg10 ;
ARCHITECTURE Behavior OF reg10 IS
BEGIN
	PROCESS ( Resetn, Clock )
	BEGIN
		IF Resetn = '0' THEN
			Q <= "0000000000" ;
		ELSIF Clock'EVENT AND Clock = '1' THEN 
			IF ld = '1' THEN Q <= D;END IF;
		END IF ;
	END PROCESS ;
END Behavior ;