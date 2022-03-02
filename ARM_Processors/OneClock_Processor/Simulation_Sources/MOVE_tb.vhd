library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.ENV.ALL;

entity MOVE_tb is
    generic(
        M : positive := 32);
end MOVE_tb;

architecture Behavioral of MOVE_tb is
    
    component MOV_MVN is
        generic (
            M : positive := 32 -- data word length
        );    
        
        Port ( 
            MON: STD_LOGIC;
            A: in STD_LOGIC_VECTOR (M-1 downto 0);
            S: out STD_LOGIC_VECTOR (M-1 downto 0)
        );
    end component;
    
    signal A, S : STD_LOGIC_VECTOR (M-1 downto 0);
    signal AC : STD_LOGIC;
    
begin

    U1 : MOV_MVN port map (
        A => A,
        S => S,
        MON => AC
    );

    process
    
    begin 
        
        -- MOVE
        AC <= '0';
        A <= X"0000000" & "1101";
        
        wait for 100 ns;
        
        -- MOVE NOT
        AC <= '1';
        A <= X"0000000" & "0111";
        wait for 100 ns;
                
        wait;
        report "COMPLETE";
        stop(2);
        
    end process;
    
end Behavioral;
