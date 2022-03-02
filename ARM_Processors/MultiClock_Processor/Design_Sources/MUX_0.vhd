
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MUX_0 is

    generic (
        M : positive := 32 -- data word length
    );


    Port (
        A: in STD_LOGIC_VECTOR (M-1 downto 0);
        B: in STD_LOGIC_VECTOR (3 downto 0);
        S: in STD_LOGIC_VECTOR (2 downto 0);
        Y: out STD_LOGIC_VECTOR (3 downto 0)
    );
end MUX_0;

architecture Behavioral of MUX_0 is

begin

    process (A, B, S)
    begin 
        if (S(0) = '0') then
            Y <= A(19 downto 16);
        else
            Y <= B;
        end if;
    end process;

end Behavioral;
