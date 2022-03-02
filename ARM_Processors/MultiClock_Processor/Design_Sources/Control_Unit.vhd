
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Unit is
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
    
    component FSM is
    Port ( 
        clk: in STD_LOGIC;
        rst: in STD_LOGIC;
        op: in STD_LOGIC_VECTOR (1 downto 0);
        S_L: in STD_LOGIC;
        Rd: in STD_LOGIC_VECTOR (3 downto 0);
        NoWrite_in: in STD_LOGIC;
        CondEx_in : in STD_LOGIC;
        IRWrite: out STD_LOGIC;
        RegWrite: out STD_LOGIC;
        MAWrite: out STD_LOGIC;
        MemWrite: out STD_LOGIC;
        FlagsWrite: out STD_LOGIC;
        PCSrc: out STD_LOGIC_VECTOR (1 downto 0);
        PCWrite: out STD_LOGIC;
        states : out STD_LOGIC_VECTOR (12 downto 0)
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
    
    -- FSM
    signal IRWrite_OUT : STD_LOGIC;
    signal RegWrite_OUT : STD_LOGIC;
    signal MAWrite_OUT : STD_LOGIC;
    signal MemWrite_OUT : STD_LOGIC;
    signal FlagsWrite_OUT : STD_LOGIC;
    signal PCSrc_OUT : STD_LOGIC_VECTOR (1 downto 0);
    signal PCWrite_OUT : STD_LOGIC;
    signal states_OUT : STD_LOGIC_VECTOR (12 downto 0);    

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
    
    F_S_M : FSM port map(
        clk => CLK,
        rst => RST,
        op => Instr(27 downto 26),
        S_L => Instr(20),
        Rd => Instr(15 downto 12),
        NoWrite_in => NoWrite_in_OUT,
        CondEx_in => CondEX_in_OUT,
        IRWrite => IRWrite_OUT,
        RegWrite => RegWrite_OUT,
        MAWrite => MAWrite_OUT,
        MemWrite => MemWrite_OUT,
        FlagsWrite => FlagsWrite_OUT,
        PCSrc => PCSrc_OUT,
        PCWrite => PCWrite_OUT,
        states => states_OUT
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
    IRWrite <= IRWrite_OUT;
    RegWrite <= RegWrite_OUT;
    MAWrite <= MAWrite_OUT;
    MemWrite <= MemWrite_OUT;
    FlagsWrite <= FlagsWrite_OUT;
    PCSrc <= PCSrc_OUT;
    PCWrite <= PCWrite_OUT;
    
end Structural;

