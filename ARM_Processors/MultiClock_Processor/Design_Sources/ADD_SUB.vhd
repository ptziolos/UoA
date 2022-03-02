
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ADD_SUB is

    generic (
        M : positive := 32 -- data word length
    );

    Port ( 
        AOS: in STD_LOGIC;
        A: in STD_LOGIC_VECTOR (M-1 downto 0);
        B: in STD_LOGIC_VECTOR (M-1 downto 0);
        S: out STD_LOGIC_VECTOR (M-1 downto 0);
        COUT: out STD_LOGIC;
        OV: out STD_LOGIC
    );
end ADD_SUB;

architecture Behavioral of ADD_SUB is
begin

    process(A, B, AOS)
        variable A_s: SIGNED (M+1 downto 0);
        variable B_s: SIGNED (M+1 downto 0);
        variable B_2s: STD_LOGIC_VECTOR (M-1 downto 0);
        variable S_s: SIGNED (M+1 downto 0);
    begin
        A_s := signed('0'&A(M-1)&A);
    
        if (AOS = '0') then
            B_s := signed('0'&B(M-1)&B);
            S_s := A_s + B_s;
        else 
            B_2s := std_logic_vector(unsigned((not(B)))+1);
            B_s := signed('0'& B_2s(M-1) & B_2s);
            S_s := A_s + B_s;
        end if;
        S <= std_logic_vector(S_s(M-1 downto 0));
        COUT <= S_s(M+1);
        OV <= S_s(M) XOR S_s(M-1);
        
    end process;

end Behavioral;
