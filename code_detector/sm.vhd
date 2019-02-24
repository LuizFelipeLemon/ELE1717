library ieee ;
use ieee.std_logic_1164.all;

entity mde_d is
    port (clk, sw: in std_logic;
          key    : in std_logic_vector(3 downto 0);
          l0,l1  : out std_logic;
          seg    : out std_logic_vector(3 downto 0));
end mde_d;

architecture ckt of mde_d is
    
    type state_type is (w, a, b, c, d, e, f, g);
    signal y : state_type := w;
    signal s : std_logic;
    signal clkd : std_logic;

    component CLK_Div is
        port (clk_in  : in  std_logic ;
              clk_out : out std_logic );
    end component;

begin
    
    box0 : CLK_Div port map(
        clk_in => clk,
        clk_out => clkd
    );
    
    process (clkd)
    begin

        if(clkd'event and clkd = '1') then
            case y is
                when w =>
                if key = "0111" then y <= a;
                else                 y <= w;end if;

                when a =>
                if    key(2 downto 0) = "111" then y <= a;
                else                               y <= b;end if;
                
                when b =>
                if    key(2 downto 0) = "111" then y <= b;
                else                               y <= c;end if;

                when c =>
                if    key(2 downto 0) = "111" then y <= c;
                else                               y <= d;end if;

                when d =>
                if    key(2 downto 0) = "111" then y <= d;
                else                               y <= e;end if;

                when e =>
                if    key(2 downto 0) = "111" then y <= e;
                else                               y <= f;end if;

                when f =>
                if    s = '1'                 then y <= g;
                else                               y <= w;end if;

                when g =>
                if   sw = '1'                 then y <= w;
                else                               y <= g;end if;

            end case;
        end if;
    end process;

    process ( y , key, s, sw)
    begin   
        case y is
            when w =>
                s <= '1';
            when a => 
                if not key(3 downto 0) = "101" then s <= '0';end if;
            when b => 
                if not key(3 downto 0) = "110" then s <= '0'; end if;
            when c => 
                if not key(3 downto 0) = "011" then s <= '0'; end if;
            when d => 
                if not key(3 downto 0) = "011" then s <= '0'; end if;
            when e => 
                if not key(3 downto 0) = "101" then s <= '0'; end if;
            when f => 
                if s = '1'                       then l0 <= '1'; end if;
            when g => 
                if sw = '1'                      then l0 <= '0'; end if;
        end case ;
    end process ;
end ckt ;
