library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Unit is
    generic(
        M : positive := 32);
    Port (
        Instr : in STD_LOGIC_VECTOR (M-1 downto 0);
        FLAGS : in STD_LOGIC_VECTOR (3 downto 0);
        RegSrc : out STD_LOGIC_VECTOR (2 downto 0);
        ALUSrc : out STD_LOGIC;
        MemtoReg : out STD_LOGIC;
        ALUControl : out STD_LOGIC_VECTOR (2 downto 0);
        ImmSrc : out STD_LOGIC;
        MemWrite : out STD_LOGIC;
        FlagsWrite : out STD_LOGIC;
        RegWrite : out STD_LOGIC;
        PCSrc : out STD_LOGIC
    );
end Control_Unit;

architecture Structural of Control_Unit is

    component Instruction_Decoder is
    Port ( 
        op: in STD_LOGIC_VECTOR (1 downto 0);
        funct: in STD_LOGIC_VECTOR (5 downto 0);
        sh: in STD_LOGIC_VECTOR (1 downto 0);
        RegSrc: out STD_LOGIC_VECTOR (2 downto 0);
        ALUControl: out STD_LOGIC_VECTOR (2 downto 0);
        ALUSrc: out STD_LOGIC;
        MemtoReg: out STD_LOGIC;
        ImmSrc: out STD_LOGIC;
        NoWrite_in: out STD_LOGIC
    );
    end component;
    
    component WE_Logic is
    Port ( 
        op : in STD_LOGIC_VECTOR (1 downto 0);
        S_L : in STD_LOGIC;
        NoWrite_in : in STD_LOGIC;
        MemWrite_in : out STD_LOGIC;
        FlagsWrite_in : out STD_LOGIC;
        RegWrite_in : out STD_LOGIC
    );
    end component;
    
    component PC_Logic is
    Port ( 
        RegWrite_in : in STD_LOGIC;
        Rd : in STD_LOGIC_VECTOR (3 downto 0);
        op : in STD_LOGIC;
        PCSrc_in : out STD_LOGIC
    );
    end component;
    
    component COND_Logic is
    Port ( 
        cond : in STD_LOGIC_VECTOR (3 downto 0);
        flags : in STD_LOGIC_VECTOR (3 downto 0);
        CondEx_in : out STD_LOGIC
    );
    end component;
    
    -- Instruction Decoder
    signal RegSrc_OUT : STD_LOGIC_VECTOR (2 downto 0);
    signal ALUSrc_OUT : STD_LOGIC;
    signal MemtoReg_OUT : STD_LOGIC;
    signal ALUControl_OUT : STD_LOGIC_VECTOR (2 downto 0);
    signal ImmSrc_OUT : STD_LOGIC;
    signal NoWrite_in_OUT : STD_LOGIC;
    
    -- Write Enable Logic
    signal MemWrite_in_OUT : STD_LOGIC;
    signal FlagsWrite_in_OUT : STD_LOGIC;
    signal RegWrite_in_OUT : STD_LOGIC;
    
    -- Next Insruction Logic
    signal PCSrc_in_OUT : STD_LOGIC;
    
    -- Conditional Instr
    signal CondEX_in_OUT : STD_LOGIC;
    
begin
    
    DEC : Instruction_Decoder port map(
        op => Instr(27 downto 26),
        funct => Instr(25 downto 20),
        sh => Instr(6 downto 5),
        RegSrc => RegSrc_OUT,
        ALUSrc => ALUSrc_OUT,
        MemtoReg => MemtoReg_OUT,
        ALUControl => ALUControl_OUT,
        ImmSrc => ImmSrc_OUT,
        NoWrite_in => NoWrite_in_OUT
    );
    WE : WE_Logic port map(
        op => Instr(27 downto 26),
        S_L => Instr(20),
        NoWrite_in => NoWrite_in_OUT,
        MemWrite_in => MemWrite_in_OUT,
        FlagsWrite_in => FlagsWrite_in_OUT,
        RegWrite_in => RegWrite_in_OUT
    );
    NextInstr : PC_Logic port map(
        RegWrite_in => RegWrite_in_OUT,
        Rd => Instr(15 downto 12),
        op => Instr(27),
        PCSrc_in => PCSrc_in_OUT
    );
    CON : COND_Logic port map(
        cond => Instr(31 downto 28),
        flags => FLAGS,
        CondEx_in => CondEX_in_OUT
    );
    RegSrc <= RegSrc_OUT;
    ALUSrc <= ALUSrc_OUT;
    MemtoReg <= MemtoReg_OUT;
    ALUControl <= ALUControl_OUT;
    ImmSrc <= ImmSrc_OUT;
    MemWrite <= '1' when (MemWrite_in_OUT and CondEX_in_OUT) = '1' else '0';
    FlagsWrite <= '1' when (FlagsWrite_in_OUT and CondEX_in_OUT) = '1' else '0';
    RegWrite <= '1' when (RegWrite_in_OUT and CondEX_in_OUT) = '1' else '0';
    PCSrc <= '1' when (PCSrc_in_OUT and CondEX_in_OUT) = '1' else '0';
    
end Structural;
