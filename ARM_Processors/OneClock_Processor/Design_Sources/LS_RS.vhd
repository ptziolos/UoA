library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LS_RS is
    generic (
        M : positive := 32 -- data word length
    ); 
    Port ( 
        LOR: in STD_LOGIC;
        A: in STD_LOGIC_VECTOR (M-1 downto 0);
        SHAMT5: in STD_LOGIC_VECTOR (4 downto 0);
        S: out STD_LOGIC_VECTOR (M-1 downto 0)
    );
end LS_RS;

architecture Behavioral of LS_RS is

begin

    process(A, LOR, SHAMT5)
    begin
        if (LOR = '0') then
            S <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(SHAMT5))));
        else
            S <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(SHAMT5))));
        end if;
    end process;
    
end Behavioral;
