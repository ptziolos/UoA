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
            X0 : in signed(7 downto 0);
            X1 : in signed(7 downto 0);
            X2 : in signed(7 downto 0);
            X3 : in signed(7 downto 0);
            Y0 : out signed(7 downto 0);
            Y1 : out signed(7 downto 0);
            Y2 : out signed(7 downto 0);
            Y3 : out signed(7 downto 0)
         );
    end component;
    
    signal clk : std_logic;
    signal rst : std_logic;
    signal X0,X1,X2,X3 : signed(7 downto 0):=(others=>'0');
    signal Y0,Y1,Y2,Y3 : signed(7 downto 0):=(others=>'0');
    
    constant clk_period : time := 100 ns;
    
begin

    uut : FIR port map (clk=>clk,rst=>rst,X0=>X0,X1=>X1,X2=>X2,X3=>X3,Y0=>Y0,Y1=>Y1,Y2=>Y2,Y3=>Y3);
    
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
        X0<=to_signed(1,8);
        X1<=to_signed(1,8);
        X2<=to_signed(1,8);
        X3<=to_signed(1,8);
        wait for clk_period;
        X0<=to_signed(1,8);
        X1<=to_signed(1,8);
        X2<=to_signed(1,8);
        X3<=to_signed(1,8);
        wait for clk_period;
        X0<=to_signed(1,8);
        X1<=to_signed(1,8);
        X2<=to_signed(1,8);
        X3<=to_signed(1,8);
        wait for clk_period;
        X0<=to_signed(1,8);
        X1<=to_signed(1,8);
        X2<=to_signed(1,8);
        X3<=to_signed(1,8);
        wait for clk_period;
        X0<=to_signed(1,8);
        X1<=to_signed(0,8);
        X2<=to_signed(0,8);
        X3<=to_signed(0,8);
        wait for clk_period;
        X0<=to_signed(0,8);
        X1<=to_signed(0,8);
        X2<=to_signed(0,8);
        X3<=to_signed(0,8);
        wait;
   end process;
end;