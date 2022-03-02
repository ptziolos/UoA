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
            X : in signed(7 downto 0);
            Y : out signed(7 downto 0)
         );
    end component;
    
    signal clk : std_logic;
    signal rst : std_logic;
    signal X : signed(7 downto 0):=(others=>'0');
    signal Y : signed(7 downto 0):=(others=>'0');
    
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
        X<=to_signed(1,8);
        wait for clk_period;
        X<=to_signed(1,8);
        wait for clk_period;
        X<=to_signed(1,8);
        wait for clk_period;
        X<=to_signed(1,8);
        wait for clk_period;
        X<=to_signed(1,8);
        wait for clk_period;
        X<=to_signed(1,8);
        wait for clk_period;
        X<=to_signed(1,8);
        wait for clk_period;
        X<=to_signed(1,8);
        wait for clk_period;
        X<=to_signed(1,8);
        wait for clk_period;
        X<=to_signed(1,8);
        wait for clk_period;
        X<=to_signed(1,8);
        wait for clk_period;
        X<=to_signed(1,8);
        wait for clk_period;
        X<=to_signed(1,8);
        wait for clk_period;
        X<=to_signed(1,8);
        wait for clk_period;
        X<=to_signed(1,8);
        wait for clk_period;
        X<=to_signed(1,8);
        wait for clk_period;
        X<=to_signed(1,8);
        wait for clk_period;
        X<=to_signed(0,8);
        wait;
   end process;
end;
