library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIR is 
Port (
        clk : in std_logic;
        rst : in std_logic;
        X : in signed(15 downto 0);
        Y : out signed(15 downto 0)
     );
end FIR;

architecture Behavioral of FIR is 
    
    component DFF is 
    Port ( 
            clk : in std_logic;
            rst : in std_logic;
            D : in signed(15 downto 0);
            Q : out signed(15 downto 0)
         );
    end component;
    
    type s_array is array (0 to 15) of signed(15 downto 0);
    signal s_H,s_X,s_D : s_array:= (others=>(others=>'0'));
    signal s_Y : signed(35 downto 0):=(others=>'0');
    
begin

    s_H(0)<="0000000000101101";
    s_H(1)<="0000011010100101";
    s_H(2)<="0000101111111010";
    s_H(3)<="0000111101000000";
    s_H(4)<="0000111111100111";
    s_H(5)<="0000110111010011";
    s_H(6)<="0000100101011111";
    s_H(7)<="0000001101001111";
    s_H(8)<="1111110010101101";
    s_H(9)<="1111011010011110";
    s_H(10)<="1111001000101011";
    s_H(11)<="1111000000011000";
    s_H(12)<="1111000011000000";
    s_H(13)<="1111010000000111";
    s_H(14)<="1111100101011100";
    s_H(15)<="1111111111010101";
    
    DFF1 : DFF port map(clk=>clk,rst=>rst,D=>s_D(1),Q=>s_X(1));
    DFF2 : DFF port map(clk=>clk,rst=>rst,D=>s_D(2),Q=>s_X(2));
    DFF3 : DFF port map(clk=>clk,rst=>rst,D=>s_D(3),Q=>s_X(3));
    DFF4 : DFF port map(clk=>clk,rst=>rst,D=>s_D(4),Q=>s_X(4));
    DFF5 : DFF port map(clk=>clk,rst=>rst,D=>s_D(5),Q=>s_X(5));
    DFF6 : DFF port map(clk=>clk,rst=>rst,D=>s_D(6),Q=>s_X(6));
    DFF7 : DFF port map(clk=>clk,rst=>rst,D=>s_D(7),Q=>s_X(7));
    DFF8 : DFF port map(clk=>clk,rst=>rst,D=>s_D(8),Q=>s_X(8));
    DFF9 : DFF port map(clk=>clk,rst=>rst,D=>s_D(9),Q=>s_X(9));
    DFF10 : DFF port map(clk=>clk,rst=>rst,D=>s_D(10),Q=>s_X(10));
    DFF11 : DFF port map(clk=>clk,rst=>rst,D=>s_D(11),Q=>s_X(11));
    DFF12 : DFF port map(clk=>clk,rst=>rst,D=>s_D(12),Q=>s_X(12));
    DFF13 : DFF port map(clk=>clk,rst=>rst,D=>s_D(13),Q=>s_X(13));
    DFF14 : DFF port map(clk=>clk,rst=>rst,D=>s_D(14),Q=>s_X(14));
    DFF15 : DFF port map(clk=>clk,rst=>rst,D=>s_D(15),Q=>s_X(15));
    
    process(clk,rst)
    begin
        if rst='1' then 
            s_X(0)<=(others=>'0');
        elsif  rising_edge(clk) then
            s_X(0)<=X;
        end if;
    end process;
    
    s_D(15)<=s_X(14);
    s_D(14)<=s_X(13);
    s_D(13)<=s_X(12);
    s_D(12)<=s_X(11);
    s_D(11)<=s_X(10);
    s_D(10)<=s_X(9);
    s_D(9)<=s_X(8);
    s_D(8)<=s_X(7);
    s_D(7)<=s_X(6);
    s_D(6)<=s_X(5);
    s_D(5)<=s_X(4);
    s_D(4)<=s_X(3);
    s_D(3)<=s_X(2);
    s_D(2)<=s_X(1);
    s_D(1)<=s_X(0);
    
    s_Y<=resize(s_X(0)*s_H(0),36)+resize(s_X(1)*s_H(1),36)+resize(s_X(2)*s_H(2),36)+resize(s_X(3)*s_H(3),36)
        +resize(s_X(4)*s_H(4),36)+resize(s_X(5)*s_H(5),36)+resize(s_X(6)*s_H(6),36)+resize(s_X(7)*s_H(7),36)
        +resize(s_X(8)*s_H(8),36)+resize(s_X(9)*s_H(9),36)+resize(s_X(10)*s_H(10),36)+resize(s_X(11)*s_H(11),36)
        +resize(s_X(12)*s_H(12),36)+resize(s_X(13)*s_H(13),36)+resize(s_X(14)*s_H(14),36)+resize(s_X(15)*s_H(15),36);
        
    Y<=s_Y(35) & s_Y(26 downto 24) & s_Y(23 downto 12);

end Behavioral;