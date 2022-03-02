library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC_INC4 is
    generic(
        M : positive := 32 -- data word length
    );

    Port (
        PC: in  STD_LOGIC_VECTOR (M-1 downto 0);
        PCPlus4: out  STD_LOGIC_VECTOR (M-1 downto 0)
     );
end PC_INC4;

architecture Behavioral of PC_INC4 is

begin

PCPlus4 <= std_logic_vector(unsigned(PC) + 4);

end Behavioral;
