library ieee;
use ieee.std_logic_1164.all;

entity ADD3 is
    port (  ADD3_in: in std_logic_vector(3 downto 0); 
            ADD3_out : out std_logic_vector(3 downto 0) 
			);
end ADD3 ;

architecture ckt of ADD3 is
    
begin
    ADD3_out(3) <= (ADD3_in(3)) or (ADD3_in(2) and ADD3_in(0)) or (ADD3_in(2) and ADD3_in(1));
    ADD3_out(2) <= (ADD3_in(3) and ADD3_in(0)) or (ADD3_in(2) and not ADD3_in(1) and not ADD3_in(0));
    ADD3_out(1) <= (not ADD3_in(2) and ADD3_in(1)) or (ADD3_in(1) and ADD3_in(0)) or( ADD3_in(3) and not ADD3_in(0));
    ADD3_out(0) <= (ADD3_in(3) and not ADD3_in(0)) or (not ADD3_in(3) and not ADD3_in(2) and ADD3_in(0)) or (ADD3_in(2) and ADD3_in(1) and not ADD3_in(0));

end ckt ;
