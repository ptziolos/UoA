library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CPU_tb is
    generic(
        M : positive := 32);
end CPU_tb;

architecture Behavioral of CPU_tb is

    component CPU is
    Port (
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        PC : out STD_LOGIC_VECTOR (M-1 downto 0);
        ALUResult : out STD_LOGIC_VECTOR (M-1 downto 0);
        WriteData : out STD_LOGIC;
        Instruction : out STD_LOGIC_VECTOR (M-1 downto 0);
        Result : out STD_LOGIC_VECTOR (M-1 downto 0)
    );
    end component;
    
    signal CLK, RESET, WE, WriteData : STD_LOGIC;
    signal PC, Instr, ALU_RESULT, RESULT : STD_LOGIC_VECTOR (M-1 downto 0);
    constant clk_period: time := 13.431 ns;
    
begin

    CP: CPU port map(
        CLK => CLK,
        RESET => RESET,
        Instruction => Instr,
        PC => PC,
        ALUResult => ALU_RESULT,
        WriteData => WriteData,
        Result => RESULT
    );
    
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        
        clk <= '1';
        wait for clk_period/2;
    end process;
                  
    CPU_Process : process
    
    begin
    
        RESET <= '1';
        WE <= '0';
        wait for 100 ns;
        RESET <= '0';
        WE <= '1';
        wait;

    end process;
    

end Behavioral;
