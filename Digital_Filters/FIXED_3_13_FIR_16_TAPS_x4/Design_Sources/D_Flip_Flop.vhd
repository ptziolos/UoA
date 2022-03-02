library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DFF is
Port ( 
        clk : in std_logic;
        rst : in std_logic;
        D : in signed(15 downto 0);
        Q : out signed(15 downto 0)
     );
end DFF;

architecture Behavioral of DFF is
    
begin

    process (clk)
    begin
        if (rst='1') then
                Q <= (others=>'0');
        elsif (clk'event and clk='1') then
            Q <= D;
        end if;
    end process;
    
end Behavioral;
