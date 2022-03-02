
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FSM_tb is
end FSM_tb;

architecture Behavioral of FSM_tb is

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
        states: out STD_LOGIC_VECTOR (12 downto 0)
    );
    end component;

    signal clk : STD_LOGIC;
    signal rst : STD_LOGIC;
    signal S_L, NoWrite_in, CondEx_in : STD_LOGIC;
    signal op: STD_LOGIC_VECTOR (1 downto 0);
    signal Rd: STD_LOGIC_VECTOR (3 downto 0);
    signal IRWrite, RegWrite, MAWrite, MemWrite, FlagsWrite, PCWrite : STD_LOGIC;
    signal PCSrc : STD_LOGIC_VECTOR (1 downto 0);
    signal states : STD_LOGIC_VECTOR (12 downto 0);
    
    constant clk_period : time := 50 ns;

begin

    clk_process : process
                  begin
                     clk <= '0';
                     wait for clk_period/2;
                     clk <= '1';
                     wait for clk_period/2;
                  end process;

    U1: FSM port map(
        clk => clk,
        rst => rst,
        op => op,
        S_L => S_L,
        Rd => Rd,
        NoWrite_in => NoWrite_in,
        CondEx_in => CondEx_in,
        IRWrite => IRWrite,
        RegWrite => RegWrite,
        MAWrite => MAWrite,
        MemWrite => MemWrite,
        FlagsWrite => FlagsWrite,
        PCSrc => PCSrc,
        PCWrite => PCWrite,
        states => states
    );
    
    F: process
    
    begin
        
        rst <= '1';
        wait for 100 ns;
        
        rst <= '0';
        wait for 100 ns;
        
        op <= "00";
        S_L <= '1';
        Rd <= "0001";
        NoWrite_in <= '1';
        CondEx_in <= '1';
        wait for 200 ns;
        
        op <= "01";
        S_L <= '1';
        Rd <= "0001";
        NoWrite_in <= '1';
        CondEx_in <= '1';
        wait for 200 ns;
        
        op <= "00";
        S_L <= '1';
        Rd <= "0001";
        NoWrite_in <= '1';
        CondEx_in <= '1';
        wait for 200 ns;
        
        op <= "00";
        S_L <= '1';
        Rd <= "0001";
        NoWrite_in <= '1';
        CondEx_in <= '1';
        
        wait;

    end process;

end Behavioral;
