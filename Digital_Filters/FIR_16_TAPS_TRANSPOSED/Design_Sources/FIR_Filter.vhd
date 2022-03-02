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
    
    type s1_array is array (0 to 15) of signed(7 downto 0);
    signal s_H,s_X : s1_array:= (others=>(others=>'0'));
    
    type s2_array is array (1 to 15) of signed(7 downto 0);
    signal s_Q : s2_array:= (others=>(others=>'0'));
    signal s_D : s2_array:= (others=>(others=>'0'));
    
    signal s_I : std_logic:= '0';
    
begin

    G1: for i in 0 to 15 generate
        s_H(i)<=to_signed(1,8);
    end generate;
    
    G2: for j in 0 to 15 generate
        s_X(j)<=resize(s_H(j)*X,8) when s_I='1' else to_signed(0,31);
    end generate;
    
    G3: for k in 1 to 15 generate
        s_D(k)<=resize(s_Q(k)+s_X(15-k),8) when s_I='1' else to_signed(0,31);
    end generate;
    
    DFF1 : DFF port map(clk=>clk,rst=>rst,D=>s_X(15),Q=>s_Q(1));
    DFF2 : DFF port map(clk=>clk,rst=>rst,D=>s_D(1),Q=>s_Q(2));
    DFF3 : DFF port map(clk=>clk,rst=>rst,D=>s_D(2),Q=>s_Q(3));
    DFF4 : DFF port map(clk=>clk,rst=>rst,D=>s_D(3),Q=>s_Q(4));
    DFF5 : DFF port map(clk=>clk,rst=>rst,D=>s_D(4),Q=>s_Q(5));
    DFF6 : DFF port map(clk=>clk,rst=>rst,D=>s_D(5),Q=>s_Q(6));
    DFF7 : DFF port map(clk=>clk,rst=>rst,D=>s_D(6),Q=>s_Q(7));
    DFF8 : DFF port map(clk=>clk,rst=>rst,D=>s_D(7),Q=>s_Q(8));
    DFF9 : DFF port map(clk=>clk,rst=>rst,D=>s_D(8),Q=>s_Q(9));
    DFF10 : DFF port map(clk=>clk,rst=>rst,D=>s_D(9),Q=>s_Q(10));
    DFF11 : DFF port map(clk=>clk,rst=>rst,D=>s_D(10),Q=>s_Q(11));
    DFF12 : DFF port map(clk=>clk,rst=>rst,D=>s_D(11),Q=>s_Q(12));
    DFF13 : DFF port map(clk=>clk,rst=>rst,D=>s_D(12),Q=>s_Q(13));
    DFF14 : DFF port map(clk=>clk,rst=>rst,D=>s_D(13),Q=>s_Q(14));
    DFF15 : DFF port map(clk=>clk,rst=>rst,D=>s_D(14),Q=>s_Q(15));
    
    process(clk,rst)
    begin
        if rst='1' then 
            s_I<='0';
            Y<=(others=>'0');
        elsif rising_edge(clk) then
            s_I<='1';
            Y<=s_D(15);
        end if;
    end process;

end Behavioral;