library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIR_tb is
end FIR_tb;

architecture Behavioral of FIR_tb is
    
    component FIR is
    Port (
            clk : in std_logic;
            rst : in std_logic;
            X : in signed(15 downto 0);
            Y : out signed(15 downto 0)
         );
    end component;
    
    signal clk : std_logic;
    signal rst : std_logic;
    signal X : signed(15 downto 0):=(others=>'0');
    signal Y : signed(15 downto 0):=(others=>'0');
    
    constant clk_period : time := 20 ns;
    
begin

    uut : FIR port map (clk=>clk,rst=>rst,X=>X,Y=>Y);
    
    clocking : process
    begin
        clk<='0';
        wait for clk_period/2;
        clk<='1';
        wait for clk_period/2;
    end process;
    
    stimulus : process 
    begin
        rst<='1';
        wait for clk_period;
        rst<='0';
        X<="0000111111111111";
        wait for clk_period;
        X<="0000111010001101";
        wait for clk_period;
        X<="0000101010011011";
        wait for clk_period;
        X<="0000010011010111";
        wait for clk_period;
        X<="1111111000111110";
        wait for clk_period;
        X<="1111011111110010";
        wait for clk_period;
        X<="1111001100001000";
        wait for clk_period;
        X<="1111000001011000";
        wait for clk_period;
        X<="1111000001011001";
        wait for clk_period;
        X<="1111001100001001";
        wait for clk_period;
        X<="1111011111110100";
        wait for clk_period;
        X<="1111111001000001";
        wait for clk_period;
        X<="0000010011011010";
        wait for clk_period;
        X<="0000101010011110";
        wait for clk_period;
        X<="0000111010001111";
        wait for clk_period;
        X<="0000111111111111";
        wait for clk_period;
        X<=to_signed(0,16);
        wait;
   end process;
end;
