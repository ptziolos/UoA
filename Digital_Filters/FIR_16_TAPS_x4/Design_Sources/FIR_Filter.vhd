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
    
    type s_array is array (0 to 15) of signed(7 downto 0);
    signal s_H : s_array:= (others=>(others=>'0'));
    
    type s_2d_array is array (0 to 3) of s_array;
    signal s_X : s_2d_array:= (others=>(others=>(others=>'0')));
    
    type array_1 is array (0 to 14) of signed(7 downto 0);
    signal s_Q0,s_Q1,s_Q2,s_Q3 : array_1:= (others=>(others=>'0'));
    
    type array_2 is array (0 to 10) of signed(7 downto 0);
    signal s_W0,s_W1,s_W2,s_W3 : array_2:= (others=>(others=>'0'));
    
    type array_3 is array (0 to 6) of signed(7 downto 0);
    signal s_Z0,s_Z1,s_Z2,s_Z3 : array_3:= (others=>(others=>'0'));
    
    type array_4 is array (0 to 2) of signed(7 downto 0);
    signal s_V0,s_V1,s_V2,s_V3 : array_4:= (others=>(others=>'0'));
    
begin
    
    G1: for i in 0 to 15 generate
        s_H(i)<=to_signed(1,8);
    end generate;
    
    
    DFF1 : DFF port map(clk=>clk,rst=>rst,D=>X3,Q=>s_Q0(0));
    
    DFF2 : DFF port map(clk=>clk,rst=>rst,D=>X2,Q=>s_Q0(1));
    
    DFF3 : DFF port map(clk=>clk,rst=>rst,D=>X1,Q=>s_Q0(2));
    
    DFF4 : DFF port map(clk=>clk,rst=>rst,D=>X0,Q=>s_Q0(3));
    
    DFF5 : DFF port map(clk=>clk,rst=>rst,D=>X3,Q=>s_W0(0));
    DFF6 : DFF port map(clk=>clk,rst=>rst,D=>s_W0(0),Q=>s_Q0(4));
    
    DFF7 : DFF port map(clk=>clk,rst=>rst,D=>X2,Q=>s_W0(1));
    DFF8 : DFF port map(clk=>clk,rst=>rst,D=>s_W0(1),Q=>s_Q0(5));
    
    DFF9 : DFF port map(clk=>clk,rst=>rst,D=>X1,Q=>s_W0(2));
    DFF10 : DFF port map(clk=>clk,rst=>rst,D=>s_W0(2),Q=>s_Q0(6));
    
    DFF11 : DFF port map(clk=>clk,rst=>rst,D=>X0,Q=>s_W0(3));
    DFF12 : DFF port map(clk=>clk,rst=>rst,D=>s_W0(3),Q=>s_Q0(7));
    
    DFF13 : DFF port map(clk=>clk,rst=>rst,D=>X3,Q=>s_Z0(0));
    DFF14 : DFF port map(clk=>clk,rst=>rst,D=>s_Z0(0),Q=>s_W0(4));
    DFF15 : DFF port map(clk=>clk,rst=>rst,D=>s_W0(4),Q=>s_Q0(8));
    
    DFF16 : DFF port map(clk=>clk,rst=>rst,D=>X2,Q=>s_Z0(1));
    DFF17 : DFF port map(clk=>clk,rst=>rst,D=>s_Z0(1),Q=>s_W0(5));
    DFF18 : DFF port map(clk=>clk,rst=>rst,D=>s_W0(5),Q=>s_Q0(9));
    
    DFF19 : DFF port map(clk=>clk,rst=>rst,D=>X1,Q=>s_Z0(2));
    DFF20 : DFF port map(clk=>clk,rst=>rst,D=>s_Z0(2),Q=>s_W0(6));
    DFF21 : DFF port map(clk=>clk,rst=>rst,D=>s_W0(6),Q=>s_Q0(10));
    
    DFF22 : DFF port map(clk=>clk,rst=>rst,D=>X0,Q=>s_Z0(3));
    DFF23 : DFF port map(clk=>clk,rst=>rst,D=>s_Z0(3),Q=>s_W0(7));
    DFF24 : DFF port map(clk=>clk,rst=>rst,D=>s_W0(7),Q=>s_Q0(11));
    
    DFF25 : DFF port map(clk=>clk,rst=>rst,D=>X3,Q=>s_V0(0));
    DFF26 : DFF port map(clk=>clk,rst=>rst,D=>s_V0(0),Q=>s_Z0(4));
    DFF27 : DFF port map(clk=>clk,rst=>rst,D=>s_Z0(4),Q=>s_W0(8));
    DFF28 : DFF port map(clk=>clk,rst=>rst,D=>s_W0(8),Q=>s_Q0(12));

    DFF29 : DFF port map(clk=>clk,rst=>rst,D=>X2,Q=>s_V0(1));
    DFF30 : DFF port map(clk=>clk,rst=>rst,D=>s_V0(1),Q=>s_Z0(5));
    DFF31 : DFF port map(clk=>clk,rst=>rst,D=>s_Z0(5),Q=>s_W0(9));
    DFF32 : DFF port map(clk=>clk,rst=>rst,D=>s_W0(9),Q=>s_Q0(13));
    
    DFF33 : DFF port map(clk=>clk,rst=>rst,D=>X1,Q=>s_V0(2));
    DFF34 : DFF port map(clk=>clk,rst=>rst,D=>s_V0(2),Q=>s_Z0(6));
    DFF35 : DFF port map(clk=>clk,rst=>rst,D=>s_Z0(6),Q=>s_W0(10));
    DFF36 : DFF port map(clk=>clk,rst=>rst,D=>s_W0(10),Q=>s_Q0(14));
    
    
    
    DFF37 : DFF port map(clk=>clk,rst=>rst,D=>X3,Q=>s_Q1(1));
    
    DFF38 : DFF port map(clk=>clk,rst=>rst,D=>X2,Q=>s_Q1(2));
    
    DFF39 : DFF port map(clk=>clk,rst=>rst,D=>X1,Q=>s_Q1(3));
    
    DFF40 : DFF port map(clk=>clk,rst=>rst,D=>X0,Q=>s_Q1(4));
    
    DFF41 : DFF port map(clk=>clk,rst=>rst,D=>X3,Q=>s_W1(0));
    DFF42 : DFF port map(clk=>clk,rst=>rst,D=>s_W1(0),Q=>s_Q1(5));
    DFF43 : DFF port map(clk=>clk,rst=>rst,D=>X2,Q=>s_W1(1));
    DFF44 : DFF port map(clk=>clk,rst=>rst,D=>s_W1(1),Q=>s_Q1(6));
    DFF45 : DFF port map(clk=>clk,rst=>rst,D=>X1,Q=>s_W1(2));
    DFF46 : DFF port map(clk=>clk,rst=>rst,D=>s_W1(2),Q=>s_Q1(7));
    DFF47 : DFF port map(clk=>clk,rst=>rst,D=>X0,Q=>s_W1(3));
    DFF48 : DFF port map(clk=>clk,rst=>rst,D=>s_W1(3),Q=>s_Q1(8));
    
    DFF49 : DFF port map(clk=>clk,rst=>rst,D=>X3,Q=>s_Z1(0));
    DFF50 : DFF port map(clk=>clk,rst=>rst,D=>s_Z1(0),Q=>s_W1(4));
    DFF51 : DFF port map(clk=>clk,rst=>rst,D=>s_W1(4),Q=>s_Q1(9));
    
    DFF52 : DFF port map(clk=>clk,rst=>rst,D=>X2,Q=>s_Z1(1));
    DFF53 : DFF port map(clk=>clk,rst=>rst,D=>s_Z1(1),Q=>s_W1(5));
    DFF54 : DFF port map(clk=>clk,rst=>rst,D=>s_W1(5),Q=>s_Q1(10));
    
    DFF55 : DFF port map(clk=>clk,rst=>rst,D=>X1,Q=>s_Z1(2));
    DFF56 : DFF port map(clk=>clk,rst=>rst,D=>s_Z1(2),Q=>s_W1(6));
    DFF57 : DFF port map(clk=>clk,rst=>rst,D=>s_W1(6),Q=>s_Q1(11));
    
    DFF58 : DFF port map(clk=>clk,rst=>rst,D=>X0,Q=>s_Z1(3));
    DFF59 : DFF port map(clk=>clk,rst=>rst,D=>s_Z1(3),Q=>s_W1(7));
    DFF60 : DFF port map(clk=>clk,rst=>rst,D=>s_W1(7),Q=>s_Q1(12));
    
    DFF61 : DFF port map(clk=>clk,rst=>rst,D=>X3,Q=>s_V1(0));
    DFF62 : DFF port map(clk=>clk,rst=>rst,D=>s_V1(0),Q=>s_Z1(4));
    DFF63 : DFF port map(clk=>clk,rst=>rst,D=>s_Z1(4),Q=>s_W1(8));
    DFF64 : DFF port map(clk=>clk,rst=>rst,D=>s_W1(8),Q=>s_Q1(13));
    
    DFF65 : DFF port map(clk=>clk,rst=>rst,D=>X2,Q=>s_V1(1));
    DFF66 : DFF port map(clk=>clk,rst=>rst,D=>s_V1(1),Q=>s_Z1(5));
    DFF67 : DFF port map(clk=>clk,rst=>rst,D=>s_Z1(5),Q=>s_W1(9));
    DFF68 : DFF port map(clk=>clk,rst=>rst,D=>s_W1(9),Q=>s_Q1(14));

    
    
    DFF69 : DFF port map(clk=>clk,rst=>rst,D=>X3,Q=>s_Q2(2));
    
    DFF70 : DFF port map(clk=>clk,rst=>rst,D=>X2,Q=>s_Q2(3));
    
    DFF71 : DFF port map(clk=>clk,rst=>rst,D=>X1,Q=>s_Q2(4));
    
    DFF72 : DFF port map(clk=>clk,rst=>rst,D=>X0,Q=>s_Q2(5));
    
    DFF73 : DFF port map(clk=>clk,rst=>rst,D=>X3,Q=>s_W2(0));
    DFF74 : DFF port map(clk=>clk,rst=>rst,D=>s_W2(0),Q=>s_Q2(6));
    
    DFF75 : DFF port map(clk=>clk,rst=>rst,D=>X2,Q=>s_W2(1));
    DFF76 : DFF port map(clk=>clk,rst=>rst,D=>s_W2(1),Q=>s_Q2(7));
    
    DFF77 : DFF port map(clk=>clk,rst=>rst,D=>X1,Q=>s_W2(2));
    DFF78 : DFF port map(clk=>clk,rst=>rst,D=>s_W2(2),Q=>s_Q2(8));
    
    DFF79 : DFF port map(clk=>clk,rst=>rst,D=>X0,Q=>s_W2(3));
    DFF80 : DFF port map(clk=>clk,rst=>rst,D=>s_W2(3),Q=>s_Q2(9));
    
    DFF81 : DFF port map(clk=>clk,rst=>rst,D=>X3,Q=>s_Z2(0));
    DFF82 : DFF port map(clk=>clk,rst=>rst,D=>s_Z2(0),Q=>s_W2(4));
    DFF83 : DFF port map(clk=>clk,rst=>rst,D=>s_W2(4),Q=>s_Q2(10));
    
    DFF84 : DFF port map(clk=>clk,rst=>rst,D=>X2,Q=>s_Z2(1));
    DFF85 : DFF port map(clk=>clk,rst=>rst,D=>s_Z2(1),Q=>s_W2(5));
    DFF86 : DFF port map(clk=>clk,rst=>rst,D=>s_W2(5),Q=>s_Q2(11));
    
    DFF87 : DFF port map(clk=>clk,rst=>rst,D=>X1,Q=>s_Z2(2));
    DFF88 : DFF port map(clk=>clk,rst=>rst,D=>s_Z2(2),Q=>s_W2(6));
    DFF89 : DFF port map(clk=>clk,rst=>rst,D=>s_W2(6),Q=>s_Q2(12));
    
    DFF90 : DFF port map(clk=>clk,rst=>rst,D=>X0,Q=>s_Z2(3));
    DFF91 : DFF port map(clk=>clk,rst=>rst,D=>s_Z2(3),Q=>s_W2(7));
    DFF92 : DFF port map(clk=>clk,rst=>rst,D=>s_W2(7),Q=>s_Q2(13));
    
    DFF93 : DFF port map(clk=>clk,rst=>rst,D=>X3,Q=>s_V2(0));
    DFF94 : DFF port map(clk=>clk,rst=>rst,D=>s_V2(0),Q=>s_Z2(4));
    DFF95 : DFF port map(clk=>clk,rst=>rst,D=>s_Z2(4),Q=>s_W2(8));
    DFF96 : DFF port map(clk=>clk,rst=>rst,D=>s_W2(8),Q=>s_Q2(14));
    
    
    
    DFF97 : DFF port map(clk=>clk,rst=>rst,D=>X3,Q=>s_Q3(3));
    
    DFF98 : DFF port map(clk=>clk,rst=>rst,D=>X2,Q=>s_Q3(4));
    
    DFF99 : DFF port map(clk=>clk,rst=>rst,D=>X1,Q=>s_Q3(5));
    
    DFF100 : DFF port map(clk=>clk,rst=>rst,D=>X0,Q=>s_Q3(6));
    
    DFF101 : DFF port map(clk=>clk,rst=>rst,D=>X3,Q=>s_W3(0));
    DFF102 : DFF port map(clk=>clk,rst=>rst,D=>s_W3(0),Q=>s_Q3(7));
    
    DFF103 : DFF port map(clk=>clk,rst=>rst,D=>X2,Q=>s_W3(1));
    DFF104 : DFF port map(clk=>clk,rst=>rst,D=>s_W3(1),Q=>s_Q3(8));
    
    DFF105 : DFF port map(clk=>clk,rst=>rst,D=>X1,Q=>s_W3(2));
    DFF106 : DFF port map(clk=>clk,rst=>rst,D=>s_W3(2),Q=>s_Q3(9));
    
    DFF107 : DFF port map(clk=>clk,rst=>rst,D=>X0,Q=>s_W3(3));
    DFF108 : DFF port map(clk=>clk,rst=>rst,D=>s_W3(3),Q=>s_Q3(10));
    
    DFF109 : DFF port map(clk=>clk,rst=>rst,D=>X3,Q=>s_Z3(0));
    DFF110 : DFF port map(clk=>clk,rst=>rst,D=>s_Z3(0),Q=>s_W3(4));
    DFF111 : DFF port map(clk=>clk,rst=>rst,D=>s_W3(4),Q=>s_Q3(11));
    
    DFF112 : DFF port map(clk=>clk,rst=>rst,D=>X2,Q=>s_Z3(1));
    DFF113 : DFF port map(clk=>clk,rst=>rst,D=>s_Z3(1),Q=>s_W3(5));
    DFF114 : DFF port map(clk=>clk,rst=>rst,D=>s_W3(5),Q=>s_Q3(12));
    
    DFF115 : DFF port map(clk=>clk,rst=>rst,D=>X1,Q=>s_Z3(2));
    DFF116 : DFF port map(clk=>clk,rst=>rst,D=>s_Z3(2),Q=>s_W3(6));
    DFF117 : DFF port map(clk=>clk,rst=>rst,D=>s_W3(6),Q=>s_Q3(13));
    
    DFF118 : DFF port map(clk=>clk,rst=>rst,D=>X0,Q=>s_Z3(3));
    DFF119 : DFF port map(clk=>clk,rst=>rst,D=>s_Z3(3),Q=>s_W3(7));
    DFF120 : DFF port map(clk=>clk,rst=>rst,D=>s_W3(7),Q=>s_Q3(14));
    
    
    process(clk,rst,X0,X1,X2,X3)
        begin
        if rst='1' then 
            for k in 0 to 3 loop
                for l in 0 to 15 loop
                    s_X(k)(l)<=(others=>'0');
                end loop;
            end loop;
        elsif rising_edge(clk) then
            s_X(0)(0)<=X0;
            s_X(0)(1)<=s_Q0(0);
            s_X(0)(2)<=s_Q0(1);
            s_X(0)(3)<=s_Q0(2);
            s_X(0)(4)<=s_Q0(3);
            s_X(0)(5)<=s_Q0(4);
            s_X(0)(6)<=s_Q0(5);
            s_X(0)(7)<=s_Q0(6);
            s_X(0)(8)<=s_Q0(7);
            s_X(0)(9)<=s_Q0(8);
            s_X(0)(10)<=s_Q0(9);
            s_X(0)(11)<=s_Q0(10);
            s_X(0)(12)<=s_Q0(11);
            s_X(0)(13)<=s_Q0(12);
            s_X(0)(14)<=s_Q0(13);
            s_X(0)(15)<=s_Q0(14);
             
            s_X(1)(0)<=X1;
            s_X(1)(1)<=X0;
            s_X(1)(2)<=s_Q1(1);
            s_X(1)(3)<=s_Q1(2);
            s_X(1)(4)<=s_Q1(3);
            s_X(1)(5)<=s_Q1(4);
            s_X(1)(6)<=s_Q1(5);
            s_X(1)(7)<=s_Q1(6);
            s_X(1)(8)<=s_Q1(7);
            s_X(1)(9)<=s_Q1(8);
            s_X(1)(10)<=s_Q1(9);
            s_X(1)(11)<=s_Q1(10);
            s_X(1)(12)<=s_Q1(11);
            s_X(1)(13)<=s_Q1(12);
            s_X(1)(14)<=s_Q1(13);
            s_X(1)(15)<=s_Q1(14);
             
            s_X(2)(0)<=X2;
            s_X(2)(1)<=X1;
            s_X(2)(2)<=X0;
            s_X(2)(3)<=s_Q2(2);
            s_X(2)(4)<=s_Q2(3);
            s_X(2)(5)<=s_Q2(4);
            s_X(2)(6)<=s_Q2(5);
            s_X(2)(7)<=s_Q2(6);
            s_X(2)(8)<=s_Q2(7);
            s_X(2)(9)<=s_Q2(8);
            s_X(2)(10)<=s_Q2(9);
            s_X(2)(11)<=s_Q2(10);
            s_X(2)(12)<=s_Q2(11);
            s_X(2)(13)<=s_Q2(12);
            s_X(2)(14)<=s_Q2(13);
            s_X(2)(15)<=s_Q2(14);
             
            s_X(3)(0)<=X3;
            s_X(3)(1)<=X2;
            s_X(3)(2)<=X1;
            s_X(3)(3)<=X0;
            s_X(3)(4)<=s_Q3(3);
            s_X(3)(5)<=s_Q3(4);
            s_X(3)(6)<=s_Q3(5);
            s_X(3)(7)<=s_Q3(6);
            s_X(3)(8)<=s_Q3(7);
            s_X(3)(9)<=s_Q3(8);
            s_X(3)(10)<=s_Q3(9);
            s_X(3)(11)<=s_Q3(10);
            s_X(3)(12)<=s_Q3(11);
            s_X(3)(13)<=s_Q3(12);
            s_X(3)(14)<=s_Q3(13);
            s_X(3)(15)<=s_Q3(14);
            
        end if;
    end process;
    
    Y0<=resize(resize(s_X(0)(0)*s_H(0),18)+resize(s_X(0)(1)*s_H(1),18)+resize(s_X(0)(2)*s_H(2),18)+resize(s_X(0)(3)*s_H(3),18)
              +resize(s_X(0)(4)*s_H(4),18)+resize(s_X(0)(5)*s_H(5),18)+resize(s_X(0)(6)*s_H(6),18)+resize(s_X(0)(7)*s_H(7),18)
              +resize(s_X(0)(8)*s_H(8),18)+resize(s_X(0)(9)*s_H(9),18)+resize(s_X(0)(10)*s_H(10),18)+resize(s_X(0)(11)*s_H(11),18)
              +resize(s_X(0)(12)*s_H(12),18)+resize(s_X(0)(13)*s_H(13),18)+resize(s_X(0)(14)*s_H(14),18)+resize(s_X(0)(15)*s_H(15),18),8);
              
    Y1<=resize(resize(s_X(1)(0)*s_H(0),18)+resize(s_X(1)(1)*s_H(1),18)+resize(s_X(1)(2)*s_H(2),18)+resize(s_X(1)(3)*s_H(3),18)
              +resize(s_X(1)(4)*s_H(4),18)+resize(s_X(1)(5)*s_H(5),18)+resize(s_X(1)(6)*s_H(6),18)+resize(s_X(1)(7)*s_H(7),18)
              +resize(s_X(1)(8)*s_H(8),18)+resize(s_X(1)(9)*s_H(9),18)+resize(s_X(1)(10)*s_H(10),18)+resize(s_X(1)(11)*s_H(11),18)
              +resize(s_X(1)(12)*s_H(12),18)+resize(s_X(1)(13)*s_H(13),18)+resize(s_X(1)(14)*s_H(14),18)+resize(s_X(1)(15)*s_H(15),18),8);
    
    Y2<=resize(resize(s_X(2)(0)*s_H(0),18)+resize(s_X(2)(1)*s_H(1),18)+resize(s_X(2)(2)*s_H(2),18)+resize(s_X(2)(3)*s_H(3),18)
              +resize(s_X(2)(4)*s_H(4),18)+resize(s_X(2)(5)*s_H(5),18)+resize(s_X(2)(6)*s_H(6),18)+resize(s_X(2)(7)*s_H(7),18)
              +resize(s_X(2)(8)*s_H(8),18)+resize(s_X(2)(9)*s_H(9),18)+resize(s_X(2)(10)*s_H(10),18)+resize(s_X(2)(11)*s_H(11),18)
              +resize(s_X(2)(12)*s_H(12),18)+resize(s_X(2)(13)*s_H(13),18)+resize(s_X(2)(14)*s_H(14),18)+resize(s_X(2)(15)*s_H(15),18),8);
    
    Y3<=resize(resize(s_X(3)(0)*s_H(0),18)+resize(s_X(3)(1)*s_H(1),18)+resize(s_X(3)(2)*s_H(2),18)+resize(s_X(3)(3)*s_H(3),18)
              +resize(s_X(3)(4)*s_H(4),18)+resize(s_X(3)(5)*s_H(5),18)+resize(s_X(3)(6)*s_H(6),18)+resize(s_X(3)(7)*s_H(7),18)
              +resize(s_X(3)(8)*s_H(8),18)+resize(s_X(3)(9)*s_H(9),18)+resize(s_X(3)(10)*s_H(10),18)+resize(s_X(3)(11)*s_H(11),18)
              +resize(s_X(3)(12)*s_H(12),18)+resize(s_X(3)(13)*s_H(13),18)+resize(s_X(3)(14)*s_H(14),18)+resize(s_X(3)(15)*s_H(15),18),8);
    
end Behavioral;