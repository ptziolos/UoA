library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_32bits is
    generic (
        M : positive := 32 -- data word length
    );
    Port (
        A: in STD_LOGIC_VECTOR (M-1 downto 0);
        B: in STD_LOGIC_VECTOR (M-1 downto 0);
        S: in STD_LOGIC;
        Y: out STD_LOGIC_VECTOR (M-1 downto 0)
    );
end MUX_32bits;

architecture Behavioral of MUX_32bits is

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
