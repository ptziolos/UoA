library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CPU is
    generic(
        M : positive := 32);
    Port (
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        PC : out STD_LOGIC_VECTOR (M-1 downto 0);
        ALUResult : out STD_LOGIC_VECTOR (M-1 downto 0);
        WriteData : out STD_LOGIC;
        Instruction : out STD_LOGIC_VECTOR (M-1 downto 0);
        Result : out STD_LOGIC_VECTOR (M-1 downto 0)
    );
end CPU;

architecture Structural of CPU is

    component Control_Unit is
    generic(
        M : positive := 32);
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
    
    component Datapath is
    generic (
        M : positive := 32 -- data word length
    );
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
        IRWrite : in STD_LOGIC;
        MAWrite: in STD_LOGIC;
        MemWrite: in STD_LOGIC;
        MemtoReg: in STD_LOGIC;
        PCSrc: in STD_LOGIC_VECTOR (1 downto 0);
        PC: out STD_LOGIC_VECTOR (M-1 downto 0);
        instr: out STD_LOGIC_VECTOR (M-1 downto 0);
        ALUResult: out STD_LOGIC_VECTOR (M-1 downto 0);
        Result: out STD_LOGIC_VECTOR (M-1 downto 0);
        flags: out STD_LOGIC_VECTOR (3 downto 0)
    );
end component;
    
    -- DataPath
    signal INSTR : STD_LOGIC_VECTOR (M-1 downto 0);
    signal FLAG : STD_LOGIC_VECTOR (3 downto 0);
    signal PCReg : STD_LOGIC_VECTOR (M-1 downto 0);
    signal ALURes : STD_LOGIC_VECTOR (M-1 downto 0);
    signal Res : STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- Control Unit
    signal RegSrc_0 : STD_LOGIC_VECTOR (2 downto 0);
    signal ALUSrc_0 : STD_LOGIC;
    signal MemtoReg_0 : STD_LOGIC;
    signal ALUControl_0 : STD_LOGIC_VECTOR (2 downto 0);
    signal ImmSrc_0 : STD_LOGIC;
    signal IRWrite_0 : STD_LOGIC;
    signal RegWrite_0 : STD_LOGIC;
    signal MAWrite_0 : STD_LOGIC;
    signal MemWrite_0 : STD_LOGIC;
    signal FlagsWrite_0 : STD_LOGIC;
    signal PCSrc_0 : STD_LOGIC_VECTOR (1 downto 0);
    signal PCWrite_0 : STD_LOGIC;
    
begin

    DP : DataPath port map(
        CLK => CLK,
        RST => RESET,
        PCWrite => PCWrite_0,
        RegSrc => RegSrc_0,
        ALUSrc => ALUSrc_0,
        MemtoReg => MemtoReg_0,
        ALUControl => ALUControl_0,
        ImmSrc => ImmSrc_0,
        RegWrite => RegWrite_0,
        IRWrite => IRWrite_0,
        MAWrite => MAWrite_0,
        MemWrite => MemWrite_0,
        FlagsWrite => FlagsWrite_0,
        PCSrc => PCSrc_0,
        INSTR => Instr,
        flags => FLAG,
        PC => PCReg,
        ALUResult => ALURes,
        Result => Res
    );
    
    CU : Control_Unit port map(
        CLK => CLK,
        RST => RESET,
        Instr => INSTR,
        FLAGS => FLAG,
        RegSrc => RegSrc_0,
        ALUSrc => ALUSrc_0,
        MemtoReg => MemtoReg_0,
        ALUControl => ALUControl_0,
        ImmSrc => ImmSrc_0,
        IRWrite => IRWrite_0,
        RegWrite => RegWrite_0,
        MAWrite => MAWrite_0,
        MemWrite => MemWrite_0,
        FlagsWrite => FlagsWrite_0,
        PCSrc => PCSrc_0,
        PCWrite => PCWrite_0
    );
    
    Instruction <= INSTR;
    PC <= PCReg;
    ALUResult <= ALURes;
    WriteData <= MemWrite_0;
    Result <= Res;

end Structural;
