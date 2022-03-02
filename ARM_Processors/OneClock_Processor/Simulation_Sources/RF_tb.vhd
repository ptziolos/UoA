
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RF_tb is
end RF_tb;

architecture Behavioral of RF_tb is

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

    signal R15, WD, RD1, RD2 : STD_LOGIC_VECTOR (31 downto 0);
    signal A1, A2, A3 : STD_LOGIC_VECTOR (3 downto 0);
    signal CLK, WE : STD_LOGIC;
    constant CLK_PERIOD : time := 100 ns;

begin

    U1: Register_File port map(
        CLK => CLK,
        WE => WE,
        A1 => A1,
        A2 => A2,
        A3 => A3,
        R15 => R15,
        WD => WD,
        RD1 => RD1,
        RD2 => RD2
    );


    CLK_PROCESS : process
    
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    RF_process: process
    
    begin
    
        WE <= '1';
        A1 <= "0000";
        A2 <= "0001";
        A3 <= "0000";
        WD <= std_logic_vector(to_unsigned(10, 32));
        wait for 100 ns;
        
        WE <= '0';
        A1 <= "0000";
        A2 <= "0001";
        A3 <= "0001";
        WD <= std_logic_vector(to_unsigned(5, 32));
        wait for 100 ns;
        
        WE <= '1';
        A1 <= "0000";
        A2 <= "0001";
        A3 <= "0001";
        WD <= std_logic_vector(to_unsigned(12, 32));
        wait ;
    end process;
    
end Behavioral;
