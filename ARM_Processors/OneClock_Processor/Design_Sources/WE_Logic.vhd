library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity WE_Logic is
    Port ( 
        op : in STD_LOGIC_VECTOR (1 downto 0);
        S_L : in STD_LOGIC;
        NoWrite_in : in STD_LOGIC;
        MemWrite_in : out STD_LOGIC;
        FlagsWrite_in : out STD_LOGIC;
        RegWrite_in : out STD_LOGIC
    );
end WE_Logic;

architecture Behavioral of WE_Logic is

begin

    MemWrite_in <= '0' when (op = "00") else
              '1' when (op = "01" and S_L = '0' and NoWrite_in = '0') else
              '0' when (op = "01" and S_L = '1' and NoWrite_in = '0') else
              '0' when (op = "10") else
              'Z';

    FlagsWrite_in <= '0' when (op = "00" and S_L = '0' and NoWrite_in = '0') else
                     '1' when (op = "00" and S_L = '1') else
                     '0' when (op = "01") else
                     '0' when (op = "10") else
                     'Z';
    
    RegWrite_in <= '1' when (op = "00" and S_L = '0' and NoWrite_in = '0') else
                   '1' when (op = "00" and S_L = '1' and NoWrite_in = '0') else
                   '0' when (op = "00" and S_L = '1' and NoWrite_in = '1') else
                   '1' when (op = "01" and S_L = '1' and NoWrite_in = '0') else
                   '0' when (op = "01" and S_L = '0' and NoWrite_in = '0') else
                   '0' when (op = "10" and NoWrite_in = '0') else
                   '1' when (op = "10" and NoWrite_in = '1') else
                   'Z';

end Behavioral;
