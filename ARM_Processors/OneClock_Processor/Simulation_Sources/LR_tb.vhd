library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.ENV.ALL;

entity LR_tb is
    generic(
        M : positive := 32);
end LR_tb;

architecture Behavioral of LR_tb is
    
    component LS_RS is
        generic (
            M : positive := 32 -- data word length
        ); 
    
        Port ( 
            LOR: STD_LOGIC;
            A: in STD_LOGIC_VECTOR (M-1 downto 0);
            SHAMT5: in STD_LOGIC_VECTOR (4 downto 0);
            S: out STD_LOGIC_VECTOR (M-1 downto 0)
        );
    end component;
    
    signal A, S : STD_LOGIC_VECTOR (M-1 downto 0);
    signal SHAMT5 : STD_LOGIC_VECTOR (4 downto 0);
    signal AC : STD_LOGIC;
    
begin

    U1 : LS_RS port map (
        A => A,
        S => S,
        LOR => AC,
        SHAMT5 => SHAMT5
    );

    process
    
    begin 
        
        SHAMT5 <= "00100";
        -- LR
        AC <= '0';
        A <= X"0000000" & "1101";
        
        wait for 100 ns;
        
        -- LR
        AC <= '0';
        A <= X"0000000" & "0111";
        wait for 100 ns;
        
        -- AS
        AC <= '1';
        A <= X"0000000" & "1101";
        
        wait for 100 ns;
        
        -- AS
        AC <= '1';
        A <= X"0000000" & "0111";
        wait for 100 ns;

        
       
        
        wait;
        report "COMPLETE";
        stop(2);
        
    end process;
    
end Behavioral;
