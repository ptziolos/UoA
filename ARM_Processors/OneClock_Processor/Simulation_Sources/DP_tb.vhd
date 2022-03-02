library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.ENV.all;

entity DP_tb is
    generic(
        M : positive := 32);
end DP_tb;

Architecture Behavioral of DP_tb is

    component DataPath is
        Port (
            CLK: in STD_LOGIC;
            RST: in STD_LOGIC;
            PCWrite: in STD_LOGIC;
            RegSrc: in STD_LOGIC_VECTOR (2 downto 0);
            RegWrite: in STD_LOGIC;
            ImmSrc: in STD_LOGIC;
            ALUSrc: in STD_LOGIC;
            ALUControl: in STD_LOGIC_VECTOR (2 downto 0);
            FlagsWrite: in STD_LOGIC;
            MemWrite: in STD_LOGIC;
            MemtoReg: in STD_LOGIC;
            PCSrc: in STD_LOGIC;
            PC: out STD_LOGIC_VECTOR (M-1 downto 0);
            instr: out STD_LOGIC_VECTOR (M-1 downto 0);
            ALUResult: out STD_LOGIC_VECTOR (M-1 downto 0);
            Result: out STD_LOGIC_VECTOR (M-1 downto 0);
            flags: out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;
    
    -- in
    signal CLK, RST, PCWrite : STD_LOGIC;
    signal REG_SRC, ALU_CONTROL : STD_LOGIC_VECTOR (2 downto 0);
    signal ALU_SRC, MemToREG, IMM_SRC, MEM_WRITE, FLAGS_WRITE, REG_WRITE, PC_SRC : STD_LOGIC;
    
    -- out
    signal Flag : STD_LOGIC_VECTOR (3 downto 0);
    signal Instr, PC, ALU_RESULT, RESULT : STD_LOGIC_VECTOR (M-1 downto 0);
    signal WRITE_DATA : STD_LOGIC;
    constant CLK_PERIOD : time := 10 ns;
    
begin
    
    DP : DataPath port map(
        CLK => CLK,
        RST => RST,
        PCWrite => PCWrite,
        RegSrc => REG_SRC,
        ALUSrc => ALU_SRC,
        MemtoReg => MemToREG,
        ALUControl => ALU_CONTROL,
        ImmSrc => IMM_SRC,
        MemWrite => MEM_WRITE,
        FlagsWrite => FLAGS_WRITE,
        RegWrite => REG_WRITE,
        PCSrc => PC_SRC,
        INSTR => Instr,
        flags => Flag,
        PC => PC,
        ALUResult => ALU_RESULT,
        Result => RESULT
    );
    
    CLK_PROCESS : process
    
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    DataPath_PROCESS : process
    
    begin
    
        RST <= '1';
        wait for 20 ns;
        RST <= '0';
        PCWrite <= '1';
        
        -- move R0, #5
        REG_SRC <= "000";
        ALU_SRC <= '1';
        MemToREG <= '0';
        ALU_CONTROL <= "001";
        IMM_SRC <= '0';
        MEM_WRITE <= '0';
        FLAGS_WRITE <= '0';
        REG_WRITE <= '1';
        PC_SRC <= '0';
        
        wait;
        
    end process;

end Behavioral;
