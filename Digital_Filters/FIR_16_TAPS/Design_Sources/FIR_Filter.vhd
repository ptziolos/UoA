library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIR is 
Port (
        clk : in std_logic;
        rst : in std_logic;
        X : in signed(7 downto 0);
        Y : out signed(7 downto 0)
     );
end FIR;

architecture Behavioral of FIR is 
    
    component DFF is 
    Port ( 
            clk : in std_logic;
            rst : in std_logic;
            D : in signed(7 downto 0);
            Q : out signed(7 downto 0)
         );
    end component;
    
    type s_array is array (0 to 15) of signed(7 downto 0);
    signal s_H,s_X,s_D : s_array:= (others=>(others=>'0'));
    
begin

    s_H(0)<=to_signed(1,8);
    s_H(1)<=to_signed(1,8);
    s_H(2)<=to_signed(1,8);
    s_H(3)<=to_signed(1,8);
    s_H(4)<=to_signed(1,8);
    s_H(5)<=to_signed(1,8);
    s_H(6)<=to_signed(1,8);
    s_H(7)<=to_signed(1,8);
    s_H(8)<=to_signed(1,8);
    s_H(9)<=to_signed(1,8);
    s_H(10)<=to_signed(1,8);
    s_H(11)<=to_signed(1,8);
    s_H(12)<=to_signed(1,8);
    s_H(13)<=to_signed(1,8);
    s_H(14)<=to_signed(1,8);
    s_H(15)<=to_signed(1,8);
    
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
    
    Y<=resize(resize(s_X(0)*s_H(0),18)+resize(s_X(1)*s_H(1),18)+resize(s_X(2)*s_H(2),18)+resize(s_X(3)*s_H(3),18)
              +resize(s_X(4)*s_H(4),18)+resize(s_X(5)*s_H(5),18)+resize(s_X(6)*s_H(6),18)+resize(s_X(7)*s_H(7),18)
              +resize(s_X(8)*s_H(8),18)+resize(s_X(9)*s_H(9),18)+resize(s_X(10)*s_H(10),18)+resize(s_X(11)*s_H(11),18)
              +resize(s_X(12)*s_H(12),18)+resize(s_X(13)*s_H(13),18)+resize(s_X(14)*s_H(14),18)+resize(s_X(15)*s_H(15),18),8);

end Behavioral;