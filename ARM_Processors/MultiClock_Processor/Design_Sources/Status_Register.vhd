
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Status_Register is

    generic(
        N : positive := 4 -- data word length
    );

    Port ( 
        CLK, RST, WE: in STD_LOGIC;
        D: in STD_LOGIC_VECTOR (N-1 downto 0);
        Q: out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end Status_Register;

architecture Behavioral of Status_Register is

begin

    process (CLK, WE, RST, D)
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
