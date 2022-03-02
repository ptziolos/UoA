library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.ENV.ALL;

entity ALU_tb is
    generic(
        M : positive := 32);
end ALU_tb;

architecture Behavioral of ALU_tb is
    
    component ALU is
        generic (
        M : positive := 32; -- data word length
        N : positive := 3 -- command word length
    );

    Port ( 
        SRC_A: in STD_LOGIC_VECTOR (M-1 downto 0);
        SRC_B: in STD_LOGIC_VECTOR (M-1 downto 0);
        ALU_CONTROL: in STD_LOGIC_VECTOR (N-1 downto 0);
        SA5: in STD_LOGIC_VECTOR (4 downto 0);
        ALU_RESULT: out STD_LOGIC_VECTOR (M-1 downto 0);
        ALU_Flags: out STD_LOGIC_VECTOR (3 downto 0)
    );
    end component;
    
    signal A, B, S : STD_LOGIC_VECTOR (M-1 downto 0);
    signal F : STD_LOGIC_VECTOR (3 downto 0);
    signal AC : STD_LOGIC_VECTOR (2 downto 0);
    signal S5 : STD_LOGIC_VECTOR (4 downto 0);
    
begin

    U1 : ALU port map (
        SRC_A => A,
        SRC_B => B,
        ALU_RESULT => S,
        ALU_Flags => F,
        ALU_CONTROL => AC,
        SA5 => S5
    );

    process
    
    begin
        
        S5 <= "00010";
        AC <= "111";
        A <= X"0000000" & "1101";
        B <= X"0000000" & "0111";
        wait for 100 ns;
        
        S5<= "00000";
        -- ADD
        AC <= "000";
        A <= X"0000000" & "1101";
        B <= X"0000000" & "0111";
        wait for 100 ns;
        
        -- SUB
        AC <= "100";
        A <= X"0000000" & "1101";
        B <= X"0000000" & "0111";
        wait for 100 ns;
        
        -- CMP
        AC <= "100";
        A <= X"0000000" & "1101";
        B <= X"0000000" & "0111";
        wait for 100 ns;       
         
        -- AND
        AC <= "010";
        A <= X"0000000" & "1101";
        B <= X"0000000" & "0111";
        wait for 100 ns;
        
        -- XOR
        AC <= "110";
        A <= X"0000000" & "1101";
        B <= X"0000000" & "0111";
        wait for 100 ns;
       
        -- MOVE
        AC <= "001";
        A <= X"0000000" & "1101";
        B <= X"0000000" & "0111";
        wait for 100 ns;
        
        -- MVN
        AC <= "101";
        A <= X"0000000" & "1101";
        B <= X"0000000" & "0111";
        wait for 100 ns;
        
        -- LSL
        S5 <= "00010";
        AC <= "011";
        A <= X"0000000" & "1101";
        B <= X"0000000" & "0111";
        wait for 100 ns;
        
        wait;
        report "COMPLETE";
        stop(2);
        
    end process;
    
end Behavioral;
