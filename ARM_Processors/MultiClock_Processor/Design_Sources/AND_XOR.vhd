
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity AND_XOR is

    generic (
        M : positive := 32 -- data word length
    );    

    Port (
        AOX: in STD_LOGIC;
        A: in STD_LOGIC_VECTOR (M-1 downto 0);
        B: in STD_LOGIC_VECTOR (M-1 downto 0);
        S: out STD_LOGIC_VECTOR (M-1 downto 0)
    );
end AND_XOR;

architecture Behavioral of AND_XOR is

begin

    process(A, B, AOX)
    begin
        if (AOX = '0') then
            S <= A AND B;
        else 
            S <= A XOR B;
        end if;
    end process;

end Behavioral;
