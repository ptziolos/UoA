library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_File is
    generic (
        N : positive := 4; -- address length
        M : positive := 32 -- data word length
    ); 
    port (
        CLK: in STD_LOGIC;
        WE: in STD_LOGIC;
        A1: in STD_LOGIC_VECTOR (N-1 downto 0);
        A2: in STD_LOGIC_VECTOR (N-1 downto 0);
        A3: in STD_LOGIC_VECTOR (N-1 downto 0);
        R15: in STD_LOGIC_VECTOR (M-1 downto 0);
        WD: in STD_LOGIC_VECTOR (M-1 downto 0);
        RD1: out STD_LOGIC_VECTOR (M-1 downto 0);
        RD2: out STD_LOGIC_VECTOR (M-1 downto 0)
    );
end Register_File;

architecture Behavioral of Register_File is

    type RF_array is array (0 to 2**N-1)
    of STD_LOGIC_VECTOR (M-1 downto 0);
    signal RF : RF_array;

begin

    process (CLK, A3, WE, WD)
    begin
        if (CLK = '1' and CLK'event) then
            if (WE = '1') then 
                RF(to_integer(unsigned(A3))) <= WD;
            end if;
        end if;
    end process;
    
    with A1 select
        RD1 <= R15 when "1111",
            RF(to_integer(unsigned(A1))) when others;
            
    RD2 <= RF(to_integer(unsigned(A2)));

end Behavioral;
