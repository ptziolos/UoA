library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC_Logic is
    Port ( 
        RegWrite_in : in STD_LOGIC;
        Rd : in STD_LOGIC_VECTOR (3 downto 0);
        op : in STD_LOGIC;
        PCSrc_in : out STD_LOGIC
    );
end PC_Logic;

architecture Behavioral of PC_Logic is

begin

    PCSrc_in <= '0' when (op = '0' and RegWrite_in = '0') else
                '1' when (op = '0' and RegWrite_in = '1' and Rd = "1111") else
                '0' when (op = '0' and RegWrite_in = '1' and not(Rd = "1111")) else
                '1' when (op = '1') else
                'Z';

end Behavioral;
