library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COND_Logic is
    Port ( 
        cond : in STD_LOGIC_VECTOR (3 downto 0);
        flags : in STD_LOGIC_VECTOR (3 downto 0);
        CondEx_in : out STD_LOGIC
    );
end COND_Logic;

architecture Behavioral of COND_Logic is

begin

     CondEx_in <= '0' when (cond = "0000" and flags(2) = '0') else
                  '1' when (cond = "0000" and flags(2) = '1') else
                  
                  '0' when (cond = "0001" and flags(2) = '1') else
                  '1' when (cond = "0001" and flags(2) = '0') else
                  
                  '0' when (cond = "0010" and flags(1) = '0') else
                  '1' when (cond = "0010" and flags(1) = '1') else
                  
                  '0' when (cond = "0011" and flags(1) = '1') else
                  '1' when (cond = "0011" and flags(1) = '0') else
                  
                  '0' when (cond = "0100" and flags(3) = '0') else
                  '1' when (cond = "0100" and flags(3) = '1') else
                  
                  '0' when (cond = "0101" and flags(3) = '1') else
                  '1' when (cond = "0101" and flags(3) = '0') else
                  
                  '0' when (cond = "0110" and flags(0) = '0') else
                  '1' when (cond = "0110" and flags(0) = '1') else
                  
                  '0' when (cond = "0111" and flags(0) = '1') else
                  '1' when (cond = "0111" and flags(0) = '0') else
                  
                  '0' when (cond = "1000" and not(flags(1) = '1' and flags(2) = '0')) else
                  '1' when (cond = "1000" and flags(1) = '1' and flags(2) = '0') else
                  
                  '0' when (cond = "1001" and not(flags(1) = '0' and flags(2) = '1')) else
                  '1' when (cond = "1001" and flags(1) = '0' and flags(2) = '1') else
                  
                  '0' when (cond = "1010" and not(flags(3) = flags(0))) else
                  '1' when (cond = "1010" and flags(3) = flags(0)) else
                  
                  '0' when (cond = "1011" and not(flags(3) /= flags(0))) else
                  '1' when (cond = "1011" and flags(3) /= flags(0)) else
                  
                  '0' when (cond = "1100" and not(flags(2) = '0' and flags(3) = '0')) else
                  '1' when (cond = "1100" and flags(2) = '0' and flags(3) = '0') else
                  
                  '0' when (cond = "1101" and not(flags(2) = '1' and flags(3) /= flags(0))) else
                  '1' when (cond = "1101" and flags(2) = '1' and flags(3) /= flags(0)) else
                  
                  '1' when (cond = "1110" or cond = "1111") else
                  
                  'Z';
    
end Behavioral;
