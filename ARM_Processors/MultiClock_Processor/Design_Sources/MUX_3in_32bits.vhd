
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MUX_3in_32bits is
    generic (
        M : positive := 32 -- data word length
    );

    Port (
        A: in STD_LOGIC_VECTOR (M-1 downto 0);
        B: in STD_LOGIC_VECTOR (M-1 downto 0);
        C: in STD_LOGIC_VECTOR (M-1 downto 0);
        S: in STD_LOGIC_VECTOR (1 downto 0);
        Y: out STD_LOGIC_VECTOR (M-1 downto 0)
    );
end MUX_3in_32bits;

architecture Behavioral of MUX_3in_32bits is

begin

    process (A, B, C, S)
    begin 
        if (S = "00") then
            Y <= A;
        elsif (S = "11") then
            Y <= B;
        elsif (S = "10") then
            Y <= C;
        else 
            Y <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
        end if;
    end process;

end Behavioral;
