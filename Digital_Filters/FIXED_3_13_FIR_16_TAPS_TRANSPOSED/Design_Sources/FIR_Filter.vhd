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
            D : in signed(30 downto 0);
            Q : out signed(30 downto 0)
         );
    end component;
    
    type s0_array is array (0 to 15) of signed(15 downto 0);
    signal s_H : s0_array:= (others=>(others=>'0'));
    
    type s1_array is array (0 to 15) of signed(30 downto 0);
    signal s_X : s1_array:= (others=>(others=>'0'));
    
    type s2_array is array (1 to 15) of signed(30 downto 0);
    signal s_Q : s2_array:= (others=>(others=>'0'));
    signal s_D : s2_array:= (others=>(others=>'0'));
    
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
        s_X(j)<=resize(s_H(j)*X,31);
     end generate;
    
    G3: for k in 1 to 15 generate
        s_D(k)<=resize((s_Q(k)+s_X(k)),31);
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
            Y<=(others=>'0');
        elsif rising_edge(clk) then
            Y<=s_D(15)(30) & s_D(15)(26 downto 24) & s_D(15)(23 downto 12);
        end if;
    end process;

end Behavioral;