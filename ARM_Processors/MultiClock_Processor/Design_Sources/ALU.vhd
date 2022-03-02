
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ALU is

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
end ALU;

architecture Structural of ALU is

    component ADD_SUB is
    generic (
        M : positive := 32 -- data word length
    );
    Port ( 
        AOS: in STD_LOGIC;
        A: in STD_LOGIC_VECTOR (M-1 downto 0);
        B: in STD_LOGIC_VECTOR (M-1 downto 0);
        S: out STD_LOGIC_VECTOR (M-1 downto 0);
        COUT: out STD_LOGIC;
        OV: out STD_LOGIC
    );
    end component;

    component AND_XOR is
    generic (
        M : positive := 32 -- data word length
    );    
    Port (
        AOX: in STD_LOGIC;
        A: in STD_LOGIC_VECTOR (M-1 downto 0);
        B: in STD_LOGIC_VECTOR (M-1 downto 0);
        S: out STD_LOGIC_VECTOR (M-1 downto 0)
    );
    end component;
    
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
    
    signal AS_R : STD_LOGIC_VECTOR (M-1 downto 0);
    signal AS_C : STD_LOGIC;
    signal AS_O : STD_LOGIC;
    signal AX_R : STD_LOGIC_VECTOR (M-1 downto 0);
    signal MN_R : STD_LOGIC_VECTOR (M-1 downto 0);
    signal LR_R : STD_LOGIC_VECTOR (M-1 downto 0);
    signal ZER : STD_LOGIC;
    signal NEG : STD_LOGIC;
    signal RES : STD_LOGIC_VECTOR (M-1 downto 0);
    
begin
    AS: ADD_SUB port map(
        AOS => ALU_CONTROL(2),
        A => SRC_A,
        B => SRC_B,
        S => AS_R,
        COUT => AS_C,
        OV => AS_O
    );
    
    AX: AND_XOR port map(
        AOX => ALU_CONTROL(2),
        A => SRC_A,
        B => SRC_B,
        S => AX_R
    );
    
    MN: MOV_MVN port map(
        MON => ALU_CONTROL(2),
        A => SRC_B,
        S => MN_R
    );
    
    LR: LS_RS port map(
        LOR => ALU_CONTROL(2),
        A => SRC_B,
        SHAMT5 => SA5,
        S => LR_R
    );
    
    with ALU_CONTROL select
        RES <= AS_R when "000",
                   AS_R when "100",
                   AX_R when "010",
                   AX_R when "110",
                   MN_R when "001",
                   MN_R when "101",
                   LR_R when "011",
                   LR_R when "111",
                   "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when others;

    ALU_RESULT <= RES;
    
    ZER <= '0' when ((RES NOR RES) /= "11111111111111111111111111111111") else
           '1' when ((RES NOR RES) = "11111111111111111111111111111111") else
           'Z';
           
    NEG <= RES(31);
                   
    ALU_Flags <= NEG & ZER & AS_C & AS_O when (ALU_CONTROL = "000" or ALU_CONTROL = "100") else
                 NEG & ZER & '0'  & '0' when (ALU_CONTROL = "010" or ALU_CONTROL = "110") else
                 "0000";

end Structural;
