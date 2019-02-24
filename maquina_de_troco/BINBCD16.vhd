library ieee;
use ieee.std_logic_1164.all;

entity BINBCD16 is
    port(  BINBCD_in: in std_logic_vector(15 downto 0) ;
            BINBCD_out : out std_logic_vector(19 downto 0) 
        );
end BINBCD16 ;

architecture ckt of BINBCD16 is
    type LotsOfSignals is array (0 to 33) of std_logic_vector(3 downto 0);
    signal C_x : LotsOfSignals;

    component ADD3 is
        port ( ADD3_in: in std_logic_vector(3 downto 0);
                ADD3_out : out std_logic_vector(3 downto 0) 
					 );
    end component ;


    
    
begin
    add0: ADD3 port map(   
        ADD3_in(3) => '0',
        ADD3_in(2 downto 0) => BINBCD_in(15 downto 13),
        ADD3_out => C_x(0)
        ); 
    add1: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(0)(2 downto 0),
        ADD3_in(0) => BINBCD_in(12),
        ADD3_out => C_x(1)
        );
    add2: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(1)(2 downto 0),
        ADD3_in(0) => BINBCD_in(11),
        ADD3_out => C_x(2)
    );
    add3_3: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(2)(2 downto 0),
        ADD3_in(0) => BINBCD_in(10),
        ADD3_out => C_x(3)
    );
    add4: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(3)(2 downto 0),
        ADD3_in(0) => BINBCD_in(9),
        ADD3_out => C_x(4)
    );

    add5: ADD3 port map(    --5 to 9
        ADD3_in(3 downto 1) => C_x(4)(2 downto 0),
        ADD3_in(0) => BINBCD_in(8),
        ADD3_out => C_x(5)
    ); 
    add6: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(5)(2 downto 0),
        ADD3_in(0) => BINBCD_in(7),
        ADD3_out => C_x(6)
    );
    add7: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(6)(2 downto 0),
        ADD3_in(0) => BINBCD_in(6),
        ADD3_out => C_x(7)
    );
    add8: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(7)(2 downto 0),
        ADD3_in(0) => BINBCD_in(5),
        ADD3_out => C_x(8)
    );
    add9: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(8)(2 downto 0),
        ADD3_in(0) => BINBCD_in(4),
        ADD3_out => C_x(9)
    );

    add10: ADD3 port map(   --10 to 14
        ADD3_in(3 downto 1) => C_x(9)(2 downto 0),
        ADD3_in(0) => BINBCD_in(3),
        ADD3_out => C_x(10)
    ); 
    add11: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(10)(2 downto 0),
        ADD3_in(0) => BINBCD_in(2),
        ADD3_out => C_x(11)
    );
    add12: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(11)(2 downto 0),
        ADD3_in(0) => BINBCD_in(1),
        ADD3_out => C_x(12)
    );
    add13: ADD3 port map(
        ADD3_in(3) => '0',
        ADD3_in(2) => C_x(0)(3),
        ADD3_in(1) => C_x(1)(3),
        ADD3_in(0) => C_x(2)(3),
        ADD3_out => C_x(13)
    );
    add14: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(13)(2 downto 0),
        ADD3_in(0) => C_x(3)(3),
        ADD3_out => C_x(14)
    );

    add15: ADD3 port map(   --15 to 19
        ADD3_in(3 downto 1) => C_x(14)(2 downto 0),
        ADD3_in(0) => C_x(4)(3),
        ADD3_out => C_x(15)
    ); 
    add16: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(15)(2 downto 0),
        ADD3_in(0) => C_x(5)(3),
        ADD3_out => C_x(16)
    );
    add17: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(16)(2 downto 0),
        ADD3_in(0) => C_x(6)(3),
        ADD3_out => C_x(17)
    );
    add18: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(17)(2 downto 0),
        ADD3_in(0) => C_x(7)(3),
        ADD3_out => C_x(18)
    );
    add19: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(18)(2 downto 0),
        ADD3_in(0) => C_x(8)(3),
        ADD3_out => C_x(19)
    );  

    add20: ADD3 port map(   --20 to 24
        ADD3_in(3 downto 1) => C_x(19)(2 downto 0),
        ADD3_in(0) => C_x(9)(3),
        ADD3_out => C_x(20)
    ); 
    add21: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(20)(2 downto 0),
        ADD3_in(0) => C_x(10)(3),
        ADD3_out => C_x(21)
    );
    add22: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(21)(2 downto 0),
        ADD3_in(0) => C_x(11)(3),
        ADD3_out => C_x(22)
    );
    add23: ADD3 port map(
        ADD3_in(3) => '0',
        ADD3_in(2) => C_x(13)(3),
        ADD3_in(1) => C_x(14)(3),
        ADD3_in(0) => C_x(15)(3),
        ADD3_out => C_x(23)
    );
    add24: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(23)(2 downto 0),
        ADD3_in(0) => C_x(16)(3),
        ADD3_out => C_x(24)
    );

    add25: ADD3 port map(   --25 to 29
        ADD3_in(3 downto 1) => C_x(24)(2 downto 0),
        ADD3_in(0) => C_x(17)(3),
        ADD3_out => C_x(25)
    ); 
    add26: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(25)(2 downto 0),
        ADD3_in(0) => C_x(18)(3),
        ADD3_out => C_x(26)  
    );
    add27: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(26)(2 downto 0),
        ADD3_in(0) => C_x(19)(3),
        ADD3_out => C_x(27)   
    );
    add28: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(27)(2 downto 0),
        ADD3_in(0) => C_x(20)(3),
        ADD3_out => C_x(28)   
    );
    add29: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(28)(2 downto 0),
        ADD3_in(0) => C_x(21)(3),
        ADD3_out => C_x(29)   
    );

    add30: ADD3 port map(   --30 to 33
        ADD3_in(3) => '0',
        ADD3_in(2) => C_x(23)(3),
        ADD3_in(1) => C_x(24)(3),
        ADD3_in(0) => C_x(25)(3),
        ADD3_out => C_x(30)
    ); 
    add31: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(30)(2 downto 0),
        ADD3_in(0) => C_x(26)(3),
        ADD3_out => C_x(31)
    );
    add32: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(31)(2 downto 0),
        ADD3_in(0) => C_x(27)(3),
        ADD3_out => C_x(32)
    );
    add33: ADD3 port map(
        ADD3_in(3 downto 1) => C_x(32)(2 downto 0),
        ADD3_in(0) => C_x(28)(3),
        ADD3_out => C_x(33)
    );
    BINBCD_out(0) <= BINBCD_in(0);
    BINBCD_out(4 downto 1) <= C_x(12)(3 downto 0);
    BINBCD_out(8 downto 5) <= C_x(22)(3 downto 0);
    BINBCD_out(12 downto 9) <= C_x(29)(3 downto 0);
    BINBCD_out(16 downto 13) <= C_x(33)(3 downto 0);
    BINBCD_out(17) <= C_x(32)(3);
    BINBCD_out(18) <= C_x(31)(3);
    BINBCD_out(19) <= C_x(30)(3);
end ckt ;
