
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Datapath is
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
        IRWrite : in STD_LOGIC;
        ALUSrc: in STD_LOGIC;
        ALUControl: in STD_LOGIC_VECTOR (2 downto 0);
        FlagsWrite: in STD_LOGIC;
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
end Datapath;

architecture Structural of Datapath is

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
    
    component Extend is
    Port ( 
        ImmSrc: in STD_LOGIC;
        X: in STD_LOGIC_VECTOR (23 downto 0);
        Y: out STD_LOGIC_VECTOR (31 downto 0)
    );
    end component;
    
    component MUX_32bits is
    generic (
        M : positive := 32 -- data word length
    );
    Port (
        A: in STD_LOGIC_VECTOR (M-1 downto 0);
        B: in STD_LOGIC_VECTOR (M-1 downto 0);
        S: in STD_LOGIC;
        Y: out STD_LOGIC_VECTOR (M-1 downto 0)
    );
    end component;
    
    component MUX_4bits is

    generic (
        M : positive := 4 -- data word length
    );
    Port (
        A: in STD_LOGIC_VECTOR (M-1 downto 0);
        B: in STD_LOGIC_VECTOR (M-1 downto 0);
        S: in STD_LOGIC;
        Y: out STD_LOGIC_VECTOR (M-1 downto 0)
    );
    end component;
    
    component PC_INC4 is
    generic(
        M : positive := 32 -- data word length
    );
    Port (
        PC: in  STD_LOGIC_VECTOR (M-1 downto 0);
        PCPlus4: out  STD_LOGIC_VECTOR (M-1 downto 0)
     );
    end component;
    
    component RAM_Array is
    generic (
        N : positive := 5; -- address length
        M : positive := 32 -- data word length
    ); 
    port (
        CLK: in STD_LOGIC;
        WE: in STD_LOGIC;
        ADDR: in STD_LOGIC_VECTOR (N-1 downto 0);
        DATA_IN: in STD_LOGIC_VECTOR (M-1 downto 0);
        DATA_OUT: out STD_LOGIC_VECTOR (M-1 downto 0)
    );
    end component;
    
    component Register_32bits is
    generic(
        M : positive := 32 -- data word length
    );
    Port ( 
        CLK, RST, WE: in STD_LOGIC;
        D: in STD_LOGIC_VECTOR (M-1 downto 0);
        Q: out STD_LOGIC_VECTOR (M-1 downto 0)
    );
    end component;
    
    component Register_File is
    generic (
        N : positive := 4; -- address length
        M : positive := 32 -- data word length
    ); 
    port (
        CLK: in STD_LOGIC;
        WE: in STD_LOGIC;
        A1: in STD_LOGIC_VECTOR (N-1 downto 0);
        A2: in STD_LOGIC_VECTOR (N-1 downto 0);
        A3: in STD_LOGIC_VECTOR (N-1 downto 0);
        R15: in STD_LOGIC_VECTOR (M-1 downto 0);
        WD: in STD_LOGIC_VECTOR (M-1 downto 0);
        RD1: out STD_LOGIC_VECTOR (M-1 downto 0);
        RD2: out STD_LOGIC_VECTOR (M-1 downto 0)
    );
    end component;
    
    component Rom_Array is
    generic (
        M : positive := 32; -- data word length
        N : positive := 6 -- address length
    );
    Port (
        ADDR: in STD_LOGIC_VECTOR (N-1 downto 0);
        DATA_OUT: out STD_LOGIC_VECTOR (M-1 downto 0)
     );
    end component;
    
    component Status_Register is
    generic(
        N : positive := 4 -- data word length
    );
    Port ( 
        CLK, RST, WE: in STD_LOGIC;
        D: in STD_LOGIC_VECTOR (N-1 downto 0);
        Q: out STD_LOGIC_VECTOR (N-1 downto 0)
    );
    end component;
    
    component MUX_3in_32bits is
    generic (
        M : positive := 32 -- data word length
    );

    Port (
        A: in STD_LOGIC_VECTOR (M-1 downto 0);
        B: in STD_LOGIC_VECTOR (M-1 downto 0);
        C: in STD_LOGIC_VECTOR (M-1 downto 0);
        S: in STD_LOGIC_VECTOR (1 downto 0);
        Y: out STD_LOGIC_VECTOR (M-1 downto 0)
    );
    end component;
    
    -- PC
    signal Q_PC: STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- Instruction Memory
    signal DATA_OUT_IM: STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- PCPlus4
    signal PCPlus4_P4: STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- Instruction Register
    signal Q_IR: STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- PCPlus4 Register
    signal Q_PCPR: STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- MUX0
    signal Y_M0: STD_LOGIC_VECTOR (3 downto 0);
    
    -- MUX1
    signal Y_M1: STD_LOGIC_VECTOR (3 downto 0);
    
    -- MUX2
    signal Y_M2: STD_LOGIC_VECTOR (3 downto 0);
    
    -- PCPlus8
    signal PCPlus4_P8: STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- Register File
    signal RD1_RF: STD_LOGIC_VECTOR (M-1 downto 0);
    signal RD2_RF: STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- Extend
    signal Y_EX: STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- A Register
    signal Q_A: STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- B Register
    signal Q_B: STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- I Register
    signal Q_I: STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- MUX4
    signal Y_M4: STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- ALU 
    signal ALU_RESULT_AL: STD_LOGIC_VECTOR (M-1 downto 0);
    signal ALU_Flags_AL: STD_LOGIC_VECTOR (3 downto 0);
    
    -- Status Register
    signal Q_SR: STD_LOGIC_VECTOR (3 downto 0);
    
    -- Memory Address Register
    signal Q_MA: STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- Memory Write Data Register
    signal Q_WD: STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- S Register
    signal Q_S: STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- RAM
    signal DATA_OUT_DM: STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- RD Register
    signal Q_RD: STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- MUX5
    signal Y_M5: STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- MUX6
    signal Y_M6: STD_LOGIC_VECTOR (M-1 downto 0);
    
begin

    P_C: Register_32bits port map(
        CLK => CLK,
        RST => RST,
        WE => PCWrite,
        D => Y_M6,
        Q => Q_PC
    );
    
    IM: Rom_Array port map(
        ADDR => Q_PC(7 downto 2),
        DATA_OUT => DATA_OUT_IM
    );
    
    PCPlus4: PC_INC4 port map(
        PC => Q_PC,
        PCPlus4 => PCPlus4_P4
    );
    
    IR: Register_32bits port map(
        CLK => CLK,
        RST => RST,
        WE => IRWrite,
        D => DATA_OUT_IM,
        Q => Q_IR
    );
    
    PCP4: Register_32bits port map(
        CLK => CLK,
        RST => RST,
        WE => '1',
        D => PCPlus4_P4,
        Q => Q_PCPR
    );
    
    M0: MUX_4bits port map(
        A => Q_IR(19 downto 16),
        B => "1111",
        S => RegSrc(0),
        Y => Y_M0
    );
    
    M1: MUX_4bits port map(
        A => Q_IR(3 downto 0),
        B => Q_IR(15 downto 12),
        S => RegSrc(1),
        Y => Y_M1
    );
    
    PCPlus8: PC_INC4 port map(
        PC => Q_PCPR,
        PCPlus4 => PCPlus4_P8
    );
    
    RF: Register_File port map(
        CLK => CLK,
        WE => RegWrite,
        A1 => Y_M0,
        A2 => Y_M1,
        A3 => Q_IR(15 downto 12),
        R15 => PCPlus4_P8,
        WD => Y_M5,
        RD1 => RD1_RF,
        RD2 => RD2_RF
    );
    
    EX: Extend port map(
        ImmSrc => ImmSrc,
        X => Q_IR(23 downto 0),
        Y => Y_EX
    );
    
    A: Register_32bits port map(
        CLK => CLK,
        RST => RST,
        WE => '1',
        D => RD1_RF,
        Q => Q_A
    );
    
    B: Register_32bits port map(
        CLK => CLK,
        RST => RST,
        WE => '1',
        D => RD2_RF, 
        Q => Q_B
    );
    
    I: Register_32bits port map(
        CLK => CLK,
        RST => RST,
        WE => '1',
        D => Y_EX,
        Q => Q_I
    );
    
    M4: MUX_32bits port map(
        A => Q_B,
        B => Q_I,
        S => ALUSrc,
        Y => Y_M4
    );
    
    AL: ALU port map(
        SRC_A => Q_A,
        SRC_B => Y_M4,
        ALU_CONTROL => ALUCONTROL,
        SA5 => Y_EX(11 downto 7),
        ALU_RESULT => ALU_RESULT_AL,
        ALU_Flags => ALU_Flags_AL
    );
    
    SR: Status_Register port map(
        CLK => CLK,
        RST => RST,
        WE => FlagsWrite,
        D => ALU_Flags_AL,
        Q => Q_SR
    );
    
    MA: Register_32bits port map(
        CLK => CLK,
        RST => RST,
        WE => MAWrite,
        D => ALU_RESULT_AL,
        Q => Q_MA
    );
    
    WD: Register_32bits port map(
        CLK => CLK,
        RST => RST,
        WE => '1',
        D => Q_B,
        Q => Q_WD
    );
    
    S: Register_32bits port map(
        CLK => CLK,
        RST => RST,
        WE => '1',
        D => ALU_RESULT_AL,
        Q => Q_S
    );
    
    DM: RAM_Array port map(
        CLK => CLK,
        WE => MemWrite,
        ADDR => Q_MA(4 downto 0),
        DATA_IN => Q_WD,
        DATA_OUT => DATA_OUT_DM
    );
    
    RD: Register_32bits port map(
        CLK => CLK,
        RST => RST,
        WE => '1',
        D => DATA_OUT_DM,
        Q => Q_RD
    );
    
    M5: MUX_32bits port map(
        A => Q_S,
        B => Q_RD,
        S => MemtoReg,
        Y => Y_M5
    );
    
    M6: MUX_3in_32bits port map(
        A => Q_PCPR,
        B => ALU_RESULT_AL,
        C => Y_M5,
        S => PCSrc,
        Y => Y_M6
    );
    
    PC <= Q_PC;
    instr <= Q_IR;
    ALUResult <= ALU_RESULT_AL;
    Result <= Y_M5;
    flags <= Q_SR;
    
end Structural;
