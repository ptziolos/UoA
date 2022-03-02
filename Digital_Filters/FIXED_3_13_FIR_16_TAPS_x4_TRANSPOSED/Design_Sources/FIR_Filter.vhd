library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIR is 
Port (
        clk : in std_logic;
        rst : in std_logic;
        X0 : in signed(15 downto 0);
        X1 : in signed(15 downto 0);
        X2 : in signed(15 downto 0);
        X3 : in signed(15 downto 0);
        Y0 : out signed(15 downto 0);
        Y1 : out signed(15 downto 0);
        Y2 : out signed(15 downto 0);
        Y3 : out signed(15 downto 0)
     );
end FIR;

architecture Behavioral of FIR is 
    
    component DFF is 
    Port ( 
            clk : in std_logic;
            rst : in std_logic;
            D : in signed(30 downto 0);
            Q : out signed(30 downto 0)
         );
    end component;
    
    type s0_array is array (0 to 15) of signed(15 downto 0);
    signal s_H : s0_array:= (others=>(others=>'0'));
    
    type s1_array is array (0 to 15) of signed(30 downto 0);
    type s1_2d_array is array (0 to 3) of s1_array;
    signal s_X : s1_2d_array:= (others=>(others=>(others=>'0')));
    
    type s2_array is array (1 to 15) of signed(30 downto 0);
    type s2_2d_array is array (0 to 3) of s2_array;
    signal s_Q : s2_array:= (others=>(others=>'0'));
    signal s_D : s2_2d_array:= (others=>(others=>(others=>'0')));
    
begin

    s_H(15)<="0000000000101101";
    s_H(14)<="0000011010100101";
    s_H(13)<="0000101111111010";
    s_H(12)<="0000111101000000";
    s_H(11)<="0000111111100111";
    s_H(10)<="0000110111010011";
    s_H(9)<="0000100101011111";
    s_H(8)<="0000001101001111";
    s_H(7)<="1111110010101101";
    s_H(6)<="1111011010011110";
    s_H(5)<="1111001000101011";
    s_H(4)<="1111000000011000";
    s_H(3)<="1111000011000000";
    s_H(2)<="1111010000000111";
    s_H(1)<="1111100101011100";
    s_H(0)<="1111111111010101";
    
    G2: for j in 0 to 15 generate
        s_X(0)(j)<=resize(s_H(j)*X0,31);
        s_X(1)(j)<=resize(s_H(j)*X1,31);
        s_X(2)(j)<=resize(s_H(j)*X2,31);
        s_X(3)(j)<=resize(s_H(j)*X3,31);
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
    
    s_D(2)(1)<=resize((s_X(1)(0)+s_X(2)(1)),31);
    s_D(3)(2)<=resize((s_D(2)(1)+s_X(3)(2)),31);
    s_D(0)(3)<=resize((s_Q(8)+s_X(0)(3)),31);
    s_D(1)(4)<=resize((s_D(0)(3)+s_X(1)(4)),31);
    s_D(2)(5)<=resize((s_D(1)(4)+s_X(2)(5)),31);
    s_D(3)(6)<=resize((s_D(2)(5)+s_X(3)(6)),31);
    s_D(0)(7)<=resize((s_Q(9)+s_X(0)(7)),31);
    s_D(1)(8)<=resize((s_D(0)(7)+s_X(1)(8)),31);
    s_D(2)(9)<=resize((s_D(1)(8)+s_X(2)(9)),31);
    s_D(3)(10)<=resize((s_D(2)(9)+s_X(3)(10)),31);
    s_D(0)(11)<=resize((s_Q(10)+s_X(0)(11)),31);
    s_D(1)(12)<=resize((s_D(0)(11)+s_X(1)(12)),31);
    s_D(2)(13)<=resize((s_D(1)(12)+s_X(2)(13)),31);
    s_D(3)(14)<=resize((s_D(2)(13)+s_X(3)(14)),31);
    s_D(0)(15)<=resize((s_Q(11)+s_X(0)(15)),31);
    
    s_D(3)(1)<=resize((s_X(2)(0)+s_X(3)(1)),31);
    s_D(0)(2)<=resize((s_Q(12)+s_X(0)(2)),31);
    s_D(1)(3)<=resize((s_D(0)(2)+s_X(1)(3)),31);
    s_D(2)(4)<=resize((s_D(1)(3)+s_X(2)(4)),31);
    s_D(3)(5)<=resize((s_D(2)(4)+s_X(3)(5)),31);
    s_D(0)(6)<=resize((s_Q(13)+s_X(0)(6)),31);
    s_D(1)(7)<=resize((s_D(0)(6)+s_X(1)(7)),31);
    s_D(2)(8)<=resize((s_D(1)(7)+s_X(2)(8)),31);
    s_D(3)(9)<=resize((s_D(2)(8)+s_X(3)(9)),31);
    s_D(0)(10)<=resize((s_Q(14)+s_X(0)(10)),31);
    s_D(1)(11)<=resize((s_D(0)(10)+s_X(1)(11)),31);
    s_D(2)(12)<=resize((s_D(1)(11)+s_X(2)(12)),31);
    s_D(3)(13)<=resize((s_D(2)(12)+s_X(3)(13)),31);
    s_D(0)(14)<=resize((s_Q(15)+s_X(0)(14)),31);
    s_D(1)(15)<=resize((s_D(0)(14)+s_X(1)(15)),31);
    
    s_D(0)(1)<=resize((s_Q(1)+s_X(0)(1)),31);
    s_D(1)(2)<=resize((s_D(0)(1)+s_X(1)(2)),31);
    s_D(2)(3)<=resize((s_D(1)(2)+s_X(2)(3)),31);
    s_D(3)(4)<=resize((s_D(2)(3)+s_X(3)(4)),31);
    s_D(0)(5)<=resize((s_Q(2)+s_X(0)(5)),31);
    s_D(1)(6)<=resize((s_D(0)(5)+s_X(1)(6)),31);
    s_D(2)(7)<=resize((s_D(1)(6)+s_X(2)(7)),31);
    s_D(3)(8)<=resize((s_D(2)(7)+s_X(3)(8)),31);
    s_D(0)(9)<=resize((s_Q(3)+s_X(0)(9)),31);
    s_D(1)(10)<=resize((s_D(0)(9)+s_X(1)(10)),31);
    s_D(2)(11)<=resize((s_D(1)(10)+s_X(2)(11)),31);
    s_D(3)(12)<=resize((s_D(2)(11)+s_X(3)(12)),31);
    s_D(0)(13)<=resize((s_Q(4)+s_X(0)(13)),31);
    s_D(1)(14)<=resize((s_D(0)(13)+s_X(1)(14)),31);
    s_D(2)(15)<=resize((s_D(1)(14)+s_X(2)(15)),31);
    
    s_D(1)(1)<=resize((s_X(0)(0)+s_X(1)(1)),31);
    s_D(2)(2)<=resize((s_D(1)(1)+s_X(2)(2)),31);
    s_D(3)(3)<=resize((s_D(2)(2)+s_X(3)(3)),31);
    s_D(0)(4)<=resize((s_Q(5)+s_X(0)(4)),31);
    s_D(1)(5)<=resize((s_D(0)(4)+s_X(1)(5)),31);
    s_D(2)(6)<=resize((s_D(1)(5)+s_X(2)(6)),31);
    s_D(3)(7)<=resize((s_D(2)(6)+s_X(3)(7)),31);
    s_D(0)(8)<=resize((s_Q(6)+s_X(0)(8)),31);
    s_D(1)(9)<=resize((s_D(0)(8)+s_X(1)(9)),31);
    s_D(2)(10)<=resize((s_D(1)(9)+s_X(2)(10)),31);
    s_D(3)(11)<=resize((s_D(2)(10)+s_X(3)(11)),31);
    s_D(0)(12)<=resize((s_Q(7)+s_X(0)(12)),31);
    s_D(1)(13)<=resize((s_D(0)(12)+s_X(1)(13)),31);
    s_D(2)(14)<=resize((s_D(1)(13)+s_X(2)(14)),31);
    s_D(3)(15)<=resize((s_D(2)(14)+s_X(3)(15)),31);
    
    process(clk,rst)
    begin
        if rst='1' then
            Y0<=(others=>'0');
            Y1<=(others=>'0');
            Y2<=(others=>'0');
            Y3<=(others=>'0');
        elsif rising_edge(clk) then
            Y0<=s_D(0)(15)(30) & s_D(0)(15)(26 downto 24) & s_D(0)(15)(23 downto 12);
            Y1<=s_D(1)(15)(30) & s_D(1)(15)(26 downto 24) & s_D(1)(15)(23 downto 12);
            Y2<=s_D(2)(15)(30) & s_D(2)(15)(26 downto 24) & s_D(2)(15)(23 downto 12);
            Y3<=s_D(3)(15)(30) & s_D(3)(15)(26 downto 24) & s_D(3)(15)(23 downto 12); 
        end if;
    end process;

end Behavioral;