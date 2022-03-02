library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MOV_MVN is
    generic (
        M : positive := 32 -- data word length
    );    
    Port ( 
        MON: in STD_LOGIC;
        A: in STD_LOGIC_VECTOR (M-1 downto 0);
        S: out STD_LOGIC_VECTOR (M-1 downto 0)
    );
end MOV_MVN;

architecture Behavioral of MOV_MVN is

begin

    process(A, MON)
    begin
        if (MON = '0') then
            S <= A;
        else 
            S <= not(A);
        end if;
    end process;
    
end Behavioral;
