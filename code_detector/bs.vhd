
library ieee ;
use ieee . std_logic_1164 .all;

entity bs is
    port (clk,bt  : in  std_logic ;
          bt_out : out std_logic );
end bs;

architecture ckt of bs is
    signal cnt : std_logic := '0';
    

begin
    
    process (clk,bt)
        begin
            if (rising_edge(bt) and cnt = '0') then
                bt_out <= clk;
                cnt <= '1';
            elseif falling_edge(clk) then
                bt_out <= '0';
            end if;
    end process;
end ckt ;
