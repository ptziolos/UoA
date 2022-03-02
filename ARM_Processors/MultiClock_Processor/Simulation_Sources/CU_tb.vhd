
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CU_tb is
    generic(
        M : positive := 32);
end CU_tb;

architecture Structural of CU_tb is

    component Control_Unit is
        Port (
            CLK: in STD_LOGIC;
            RST: in STD_LOGIC;
            Instr : in STD_LOGIC_VECTOR (M-1 downto 0);
            FLAGS : in STD_LOGIC_VECTOR (3 downto 0);
            RegSrc : out STD_LOGIC_VECTOR (2 downto 0);
            ALUSrc : out STD_LOGIC;
            MemtoReg : out STD_LOGIC;
            ALUControl : out STD_LOGIC_VECTOR (2 downto 0);
            ImmSrc : out STD_LOGIC;
            IRWrite : out STD_LOGIC;
            RegWrite : out STD_LOGIC;
            MAWrite : out STD_LOGIC;
            MemWrite : out STD_LOGIC;
            FlagsWrite : out STD_LOGIC;
            PCSrc : out STD_LOGIC_VECTOR (1 downto 0);
            PCWrite : out STD_LOGIC
        );
    end component;
    
    signal CLK, RST : STD_LOGIC;
    signal Instr : STD_LOGIC_VECTOR (M-1 downto 0);
    signal FLAGS : STD_LOGIC_VECTOR (3 downto 0);
    signal RegSrc, ALUControl : STD_LOGIC_VECTOR (2 downto 0);
    signal ALUSrc, MemtoReg, ImmSrc, MemWrite, FlagsWrite, RegWrite, IRWrite, MAWrite, PCWrite : STD_LOGIC;
    signal PCSrc : STD_LOGIC_VECTOR (1 downto 0);
    constant clk_period : time := 100 ns;
    
begin

    CU : Control_Unit port map (
        CLK => CLK,
        RST => RST,
        Instr => Instr,
        FLAGS => FLAGS,
        RegSrc => RegSrc,
        ALUSrc => ALUSrc,
        MemtoReg => MemtoReg,
        ALUControl => ALUControl,
        ImmSrc => ImmSRc,
        MemWrite => MemWrite,
        FlagsWrite => FlagsWrite,
        RegWrite => RegWrite,
        PCSrc => PCSrc,
        IRWrite => IRWrite,
        MAWrite => MAWrite,
        PCWrite => PCWrite
    );
    
    clocking: process
    begin
    
        CLK <= '0';
        wait for clk_period/2;
        CLK <= '1';
        wait for clk_period/2;
    
    end process;
    
    CntrlUnt: process
    begin
    
        RST <= '1';
        wait for 100ns;
        
        RST <= '0';
        wait for 50ns;
                
        --mvn R0, #0
        Instr <= X"E3E00000";
        FLAGS <= "0000";
        wait for 400ns;
        
        --mov R1, #2
        Instr <= X"E3A01002";
        FLAGS <= "0000";
        wait for 400ns;
        
        --add R2, R1, R0
        Instr <= X"E0812000";
        FLAGS <= "0000";
        wait for 400ns;
        
        --sub R3, R1, R0
        Instr <= X"E0413000";
        FLAGS <= "0000";
        wait for 400ns;
        
        -- xor R4, R3, R2
        Instr <= X"E0234002";
        FLAGS <= "0000";
        wait for 400ns;

        -- and R5, R3, R2
        Instr <= X"E0035002";
        FLAGS <= "0000";
        wait for 400ns;
        
        -- LSL R6, R5, #1
        Instr <= X"E1A06080";
        FLAGS <= "0000";
        wait for 400ns;
        
        -- ASR R7, R5, #1
        Instr <= X"E1A070C1";
        FLAGS <= "0000";
        wait for 400ns;
        
        -- STR R8, [R0, #4]
        Instr <= X"E5808004";
        FLAGS <= "0000";
        wait for 400ns;
        
        -- STR R9, [R2, #-4]
        Instr <= X"E5029004";
        FLAGS <= "0000";
        wait for 400ns;
        
        -- LDR R0, [R0, #4]
        Instr <= X"E5900004";
        FLAGS <= "0000";
        wait for 500ns;
        
        -- LDR R1, [R2, #-4]
        Instr <= X"E5121004";
        FLAGS <= "0000";
        wait for 500ns;
        
        -- CMP R0, R1
        Instr <= X"E1500001";
        FLAGS <= "0110";
        wait for 300ns;
        
        -- ADDEQ R10, R0, #1
        Instr <= X"02800001";
        FLAGS <= "0110";
        wait for 400ns;

        -- BL #-2
        Instr <= X"EBFFFFFC";
        FLAGS <= "0110";
        wait;
    end process;

end Structural;
