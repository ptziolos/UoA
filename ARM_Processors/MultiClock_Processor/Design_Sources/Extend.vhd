
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Extend is
    Port ( 
        ImmSrc: in STD_LOGIC;
        X: in STD_LOGIC_VECTOR (23 downto 0);
        Y: out STD_LOGIC_VECTOR (31 downto 0)
    );
end Extend;

architecture Behavioral of Extend is

begin

    process(X, ImmSrc)
    begin
        if (ImmSrc = '0') then
            Y <= std_logic_vector(resize(unsigned(X(11 downto 0)),32));
        else
            Y <= std_logic_vector(resize(signed(X&"00"),32));
        end if;
    end process;

end Behavioral;
