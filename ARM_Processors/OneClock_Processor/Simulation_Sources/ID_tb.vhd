
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ID_tb is
end ID_tb;

architecture Behavioral of ID_tb is
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

    signal instr : STD_LOGIC_VECTOR (31 downto 0);
    signal op : STD_LOGIC_VECTOR (1 downto 0);
    signal funct : STD_LOGIC_VECTOR (5 downto 0);
    signal sh : STD_LOGIC_VECTOR (1 downto 0);
    signal RegSrc : STD_LOGIC_VECTOR (2 downto 0);
    signal ALUControl : STD_LOGIC_VECTOR (2 downto 0);
    signal ALUSrc : STD_LOGIC;
    signal MemtoReg : STD_LOGIC;
    signal ImmSrc : STD_LOGIC;
    signal NoWrite_in : STD_LOGIC;

begin

    U1: Instruction_Decoder port map(
        op => instr(27 downto 26),
        funct => instr(25 downto 20),
        sh => instr(6 downto 5),
        RegSrc => RegSrc,
        ALUControl => ALUControl,
        ALUSrc => ALUSrc,
        MemtoReg => MemtoReg,
        ImmSrc => ImmSrc,
        NoWrite_in => NoWrite_in
    );


    process
    begin
    
     instr <= X"E3A0000A";
     
     wait for 50 ns;
     
     instr <= X"E3A0100A";
     wait for 50 ns;
     
     instr <= X"E0812000";
     wait for 50 ns;
     
     instr <= X"E0413000";
     wait for 50 ns;
       
     instr <= X"E0034002";
     wait for 50 ns;
     instr <= X"E0235002";
     wait for 50 ns;
     instr <= X"E1A06084";
     wait for 50 ns;
     instr <= X"E1A070C5";
     wait for 50 ns;
     instr <= X"E580000C";
     wait for 50 ns;
     instr <= X"E502000C";
     wait for 50 ns;
     instr <= X"E590800C";
     wait for 50 ns;
     instr <= X"E512900C";
     wait for 50 ns;
     instr <= X"E1500001";
     wait for 50 ns;
     instr <= X"02800001";
     wait for 50 ns;
     instr <= X"EBFFFFFD";
    wait for 50 ns;
    wait;
    
    end process;

end Behavioral;
