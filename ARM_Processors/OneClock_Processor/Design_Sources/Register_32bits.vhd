library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_32bits is
    generic(
        M : positive := 32 -- data word length
    );
    Port ( 
        CLK, RST, WE: in STD_LOGIC;
        D: in STD_LOGIC_VECTOR (M-1 downto 0);
        Q: out STD_LOGIC_VECTOR (M-1 downto 0)
    );
end Register_32bits;

architecture Behavioral of Register_32bits is
begin
    
    process (CLK, RST, WE, D)
    begin
        if (CLK'event and CLK = '1') then
            if (RST = '1') then
                Q <= (others => '0');
            elsif (WE = '1') then
                Q <= D;
            end if;
        end if;
    end process;

end Behavioral;
