
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity RAM_Array is
    generic (
        N : positive := 5; -- address length
        M : positive := 32 -- data word length
    ); 
    port (
        CLK: in STD_LOGIC;
        WE: in STD_LOGIC;
        ADDR: in STD_LOGIC_VECTOR (N-1 downto 0);
        DATA_IN: in STD_LOGIC_VECTOR (M-1 downto 0);
        DATA_OUT: out STD_LOGIC_VECTOR (M-1 downto 0)
    );
end RAM_Array;

architecture Behavioral of RAM_Array is
    type RAM_array is array (0 to 2**N-1)
    of STD_LOGIC_VECTOR (M-1 downto 0);
    signal RAM : RAM_array;
begin
    Block_RAM: process (CLK, WE, ADDR)
    begin
        if (CLK = '1' and CLK'event) then
            if (WE = '1') then RAM(to_integer(unsigned(ADDR))) <= DATA_IN;
            end if;
        end if;
    end process;
    DATA_OUT <= RAM(to_integer(unsigned(ADDR)));
end Behavioral;
