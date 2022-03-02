library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIR is 
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
    
    signal s_I : signed(7 downto 0):= (others=>'0') ;
    
    type s1_array is array (0 to 15) of signed(7 downto 0);
    type s1_2d_array is array (0 to 3) of s1_array;
    signal s_H,s_X : s1_2d_array:= (others=>(others=>(others=>'0')));
    
    type s2_array is array (1 to 15) of signed(7 downto 0);
    type s2_2d_array is array (0 to 3) of s2_array;
    signal s_Q : s2_array:= (others=>(others=>'0'));
    signal s_D : s2_2d_array:= (others=>(others=>(others=>'0')));
    
begin

    G1: for i in 0 to 15 generate
        s_H(0)(i)<=to_signed(1,8);
        s_H(1)(i)<=to_signed(1,8);
        s_H(2)(i)<=to_signed(1,8);
        s_H(3)(i)<=to_signed(1,8);
    end generate;
    
    G2: for j in 0 to 15 generate
        s_X(0)(j)<=resize(s_I*s_H(0)(j)*X0,8);
        s_X(1)(j)<=resize(s_I*s_H(1)(j)*X1,8);
        s_X(2)(j)<=resize(s_I*s_H(2)(j)*X2,8);
        s_X(3)(j)<=resize(s_I*s_H(3)(j)*X3,8);
    end generate;
    
    DFF1 : DFF port map(clk=>clk,rst=>rst,D=>s_X(3)(0),Q=>s_Q(1));
    DFF2 : DFF port map(clk=>clk,rst=>rst,D=>s_D(3)(4),Q=>s_Q(2));
    DFF3 : DFF port map(clk=>clk,rst=>rst,D=>s_D(3)(8),Q=>s_Q(3));
    DFF4 : DFF port map(clk=>clk,rst=>rst,D=>s_D(3)(12),Q=>s_Q(4));
    DFF5 : DFF port map(clk=>clk,rst=>rst,D=>s_D(3)(3),Q=>s_Q(5));
    DFF6 : DFF port map(clk=>clk,rst=>rst,D=>s_D(3)(7),Q=>s_Q(6));
    DFF7 : DFF port map(clk=>clk,rst=>rst,D=>s_D(3)(11),Q=>s_Q(7));
    DFF8 : DFF port map(clk=>clk,rst=>rst,D=>s_D(3)(2),Q=>s_Q(8));
    DFF9 : DFF port map(clk=>clk,rst=>rst,D=>s_D(3)(6),Q=>s_Q(9));
    DFF10 : DFF port map(clk=>clk,rst=>rst,D=>s_D(3)(10),Q=>s_Q(10));
    DFF11 : DFF port map(clk=>clk,rst=>rst,D=>s_D(3)(14),Q=>s_Q(11));
    DFF12 : DFF port map(clk=>clk,rst=>rst,D=>s_D(3)(1),Q=>s_Q(12));
    DFF13 : DFF port map(clk=>clk,rst=>rst,D=>s_D(3)(5),Q=>s_Q(13));
    DFF14 : DFF port map(clk=>clk,rst=>rst,D=>s_D(3)(9),Q=>s_Q(14));
    DFF15 : DFF port map(clk=>clk,rst=>rst,D=>s_D(3)(13),Q=>s_Q(15));
    
    s_D(2)(1)<=resize(s_I*(s_X(1)(0)+s_X(2)(1)),8);
    s_D(3)(2)<=resize(s_I*(s_D(2)(1)+s_X(3)(2)),8);
    s_D(0)(3)<=resize(s_I*(s_Q(8)+s_X(0)(3)),8);
    s_D(1)(4)<=resize(s_I*(s_D(0)(3)+s_X(1)(4)),8);
    s_D(2)(5)<=resize(s_I*(s_D(1)(4)+s_X(2)(5)),8);
    s_D(3)(6)<=resize(s_I*(s_D(2)(5)+s_X(3)(6)),8);
    s_D(0)(7)<=resize(s_I*(s_Q(9)+s_X(0)(7)),8);
    s_D(1)(8)<=resize(s_I*(s_D(0)(7)+s_X(1)(8)),8);
    s_D(2)(9)<=resize(s_I*(s_D(1)(8)+s_X(2)(9)),8);
    s_D(3)(10)<=resize(s_I*(s_D(2)(9)+s_X(3)(10)),8);
    s_D(0)(11)<=resize(s_I*(s_Q(10)+s_X(0)(11)),8);
    s_D(1)(12)<=resize(s_I*(s_D(0)(11)+s_X(1)(12)),8);
    s_D(2)(13)<=resize(s_I*(s_D(1)(12)+s_X(2)(13)),8);
    s_D(3)(14)<=resize(s_I*(s_D(2)(13)+s_X(3)(14)),8);
    s_D(0)(15)<=resize(s_I*(s_Q(11)+s_X(0)(15)),8);
    
    s_D(3)(1)<=resize(s_I*(s_X(2)(0)+s_X(3)(1)),8);
    s_D(0)(2)<=resize(s_I*(s_Q(12)+s_X(0)(2)),8);
    s_D(1)(3)<=resize(s_I*(s_D(0)(2)+s_X(1)(3)),8);
    s_D(2)(4)<=resize(s_I*(s_D(1)(3)+s_X(2)(4)),8);
    s_D(3)(5)<=resize(s_I*(s_D(2)(4)+s_X(3)(5)),8);
    s_D(0)(6)<=resize(s_I*(s_Q(13)+s_X(0)(6)),8);
    s_D(1)(7)<=resize(s_I*(s_D(0)(6)+s_X(1)(7)),8);
    s_D(2)(8)<=resize(s_I*(s_D(1)(7)+s_X(2)(8)),8);
    s_D(3)(9)<=resize(s_I*(s_D(2)(8)+s_X(3)(9)),8);
    s_D(0)(10)<=resize(s_I*(s_Q(14)+s_X(0)(10)),8);
    s_D(1)(11)<=resize(s_I*(s_D(0)(10)+s_X(1)(11)),8);
    s_D(2)(12)<=resize(s_I*(s_D(1)(11)+s_X(2)(12)),8);
    s_D(3)(13)<=resize(s_I*(s_D(2)(12)+s_X(3)(13)),8);
    s_D(0)(14)<=resize(s_I*(s_Q(15)+s_X(0)(14)),8);
    s_D(1)(15)<=resize(s_I*(s_D(0)(14)+s_X(1)(15)),8);
    
    s_D(0)(1)<=resize(s_I*(s_Q(1)+s_X(0)(1)),8);
    s_D(1)(2)<=resize(s_I*(s_D(0)(1)+s_X(1)(2)),8);
    s_D(2)(3)<=resize(s_I*(s_D(1)(2)+s_X(2)(3)),8);
    s_D(3)(4)<=resize(s_I*(s_D(2)(3)+s_X(3)(4)),8);
    s_D(0)(5)<=resize(s_I*(s_Q(2)+s_X(0)(5)),8);
    s_D(1)(6)<=resize(s_I*(s_D(0)(5)+s_X(1)(6)),8);
    s_D(2)(7)<=resize(s_I*(s_D(1)(6)+s_X(2)(7)),8);
    s_D(3)(8)<=resize(s_I*(s_D(2)(7)+s_X(3)(8)),8);
    s_D(0)(9)<=resize(s_I*(s_Q(3)+s_X(0)(9)),8);
    s_D(1)(10)<=resize(s_I*(s_D(0)(9)+s_X(1)(10)),8);
    s_D(2)(11)<=resize(s_I*(s_D(1)(10)+s_X(2)(11)),8);
    s_D(3)(12)<=resize(s_I*(s_D(2)(11)+s_X(3)(12)),8);
    s_D(0)(13)<=resize(s_I*(s_Q(4)+s_X(0)(13)),8);
    s_D(1)(14)<=resize(s_I*(s_D(0)(13)+s_X(1)(14)),8);
    s_D(2)(15)<=resize(s_I*(s_D(1)(14)+s_X(2)(15)),8);
    
    s_D(1)(1)<=resize(s_I*(s_X(0)(0)+s_X(1)(1)),8);
    s_D(2)(2)<=resize(s_I*(s_D(1)(1)+s_X(2)(2)),8);
    s_D(3)(3)<=resize(s_I*(s_D(2)(2)+s_X(3)(3)),8);
    s_D(0)(4)<=resize(s_I*(s_Q(5)+s_X(0)(4)),8);
    s_D(1)(5)<=resize(s_I*(s_D(0)(4)+s_X(1)(5)),8);
    s_D(2)(6)<=resize(s_I*(s_D(1)(5)+s_X(2)(6)),8);
    s_D(3)(7)<=resize(s_I*(s_D(2)(6)+s_X(3)(7)),8);
    s_D(0)(8)<=resize(s_I*(s_Q(6)+s_X(0)(8)),8);
    s_D(1)(9)<=resize(s_I*(s_D(0)(8)+s_X(1)(9)),8);
    s_D(2)(10)<=resize(s_I*(s_D(1)(9)+s_X(2)(10)),8);
    s_D(3)(11)<=resize(s_I*(s_D(2)(10)+s_X(3)(11)),8);
    s_D(0)(12)<=resize(s_I*(s_Q(7)+s_X(0)(12)),8);
    s_D(1)(13)<=resize(s_I*(s_D(0)(12)+s_X(1)(13)),8);
    s_D(2)(14)<=resize(s_I*(s_D(1)(13)+s_X(2)(14)),8);
    s_D(3)(15)<=resize(s_I*(s_D(2)(14)+s_X(3)(15)),8);
    
    process(clk,rst)
    begin
        if rst='1' then
            s_I<=(others=>'0');
            Y0<=(others=>'0');
            Y1<=(others=>'0');
            Y2<=(others=>'0');
            Y3<=(others=>'0');
        elsif rising_edge(clk) then
            s_I<=to_signed(1,8);
            Y0<=s_D(0)(15);
            Y1<=s_D(1)(15);
            Y2<=s_D(2)(15);
            Y3<=s_D(3)(15);    
        end if;
    end process;

end Behavioral;