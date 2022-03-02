
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MUX is

    generic (
        M : positive := 4 -- data word length
    );

    Port (
        A: in STD_LOGIC_VECTOR (M-1 downto 0);
        B: in STD_LOGIC_VECTOR (3 downto 0);
        S: in STD_LOGIC;
        Y: out STD_LOGIC_VECTOR (3 downto 0)
    );
end MUX;

architecture Behavioral of MUX is

begin

    process (A, B, S)
    begin 
        if (S = '0') then
            Y <= A;
        else
            Y <= B;
        end if;
    end process;

end Behavioral;
