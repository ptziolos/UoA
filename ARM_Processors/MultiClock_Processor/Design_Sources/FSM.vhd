
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FSM is
    Port ( 
        clk: in STD_LOGIC;
        rst: in STD_LOGIC;
        op: in STD_LOGIC_VECTOR (1 downto 0);
        S_L: in STD_LOGIC;
        Rd: in STD_LOGIC_VECTOR (3 downto 0);
        NoWrite_in: in STD_LOGIC;
        CondEx_in : in STD_LOGIC;
        IRWrite: out STD_LOGIC;
        RegWrite: out STD_LOGIC;
        MAWrite: out STD_LOGIC;
        MemWrite: out STD_LOGIC;
        FlagsWrite: out STD_LOGIC;
        PCSrc: out STD_LOGIC_VECTOR (1 downto 0);
        PCWrite: out STD_LOGIC;
        states : out STD_LOGIC_VECTOR (12 downto 0)
    );
end FSM;

architecture Behavioral of FSM is

    signal state : std_logic_vector(12 downto 0) := "0000000000000";
    constant S0  : std_logic_vector(12 downto 0) := "0000000000001";
    constant S1  : std_logic_vector(12 downto 0) := "0000000000010";
    constant S2a : std_logic_vector(12 downto 0) := "0000000000100";
    constant S2b : std_logic_vector(12 downto 0) := "0000000001000";
    constant S3  : std_logic_vector(12 downto 0) := "0000000010000";
    constant S4a : std_logic_vector(12 downto 0) := "0000000100000";
    constant S4b : std_logic_vector(12 downto 0) := "0000001000000";
    constant S4c : std_logic_vector(12 downto 0) := "0000010000000";
    constant S4d : std_logic_vector(12 downto 0) := "0000100000000";
    constant S4e : std_logic_vector(12 downto 0) := "0001000000000";
    constant S4f : std_logic_vector(12 downto 0) := "0010000000000";
    constant S4g : std_logic_vector(12 downto 0) := "0100000000000";
    constant S4h : std_logic_vector(12 downto 0) := "1000000000000";

begin
    
    process(op, S_L, Rd, clk, rst, NoWrite_in, CondEx_in)
    begin
        if (clk'event and clk = '1') then
            if (rst = '1') then
                state <= "0000000000000";
            elsif (rst = '0') then
                case state is
                    when "0000000000000" =>
                        IRWrite <= '1';
                        RegWrite <= '0';
                        MAWrite <= '0';
                        MemWrite <= '0';
                        FlagsWrite <= '0';
                        PCSrc <= "00";
                        PCWrite <= '0';
                        state <= S0;
                    when S0 => 
                        IRWrite <= '0';
                        RegWrite <= '0';
                        MAWrite <= '0';
                        MemWrite <= '0';
                        FlagsWrite <= '0';
                        PCSrc <= "00";
                        PCWrite <= '0';
                        state <= S1;
                    when S1 =>
                        if (CondEx_in = '0') then
                            IRWrite <= '0';
                            RegWrite <= '0';
                            MAWrite <= '0';
                            MemWrite <= '0';
                            FlagsWrite <= '0';
                            PCSrc <= "00";
                            PCWrite <= '1';
                            state <= S4c;
                        elsif (op = "01" and CondEx_in = '1') then
                            IRWrite <= '0';
                            RegWrite <= '0';
                            MAWrite <= '1';
                            MemWrite <= '0';
                            FlagsWrite <= '0';
                            PCSrc <= "00";
                            PCWrite <= '0';
                            state <= S2a;
                        elsif (op = "00" and CondEx_in = '1' and NoWrite_in = '0') then
                            IRWrite <= '0';
                            RegWrite <= '0';
                            MAWrite <= '0';
                            MemWrite <= '0';
                            FlagsWrite <= '0';
                            PCSrc <= "00";
                            PCWrite <= '0';
                            state <= S2b;
                        elsif (op = "00" and CondEx_in = '1' and NoWrite_in = '1') then
                            IRWrite <= '0';
                            RegWrite <= '0';
                            MAWrite <= '0';
                            MemWrite <= '0';
                            FlagsWrite <= '1';
                            PCSrc <= "00";
                            PCWrite <= '1';
                            state <= S4g;
                        elsif (op = "10" and CondEx_in = '1') then
                            IRWrite <= '0';
                            RegWrite <= '0';
                            MAWrite <= '0';
                            MemWrite <= '0';
                            FlagsWrite <= '0';
                            PCSrc <= "11";
                            PCWrite <= '1';
                            state <= S4h;
                        else 
                            IRWrite <= '1';
                            RegWrite <= '0';
                            MAWrite <= '0';
                            MemWrite <= '0';
                            FlagsWrite <= '0';
                            PCSrc <= "00";
                            PCWrite <= '0';
                            state <= S0;
                        end if;
                    when S2a =>
                        if (S_L = '0') then
                            IRWrite <= '0';
                            RegWrite <= '0';
                            MAWrite <= '0';
                            MemWrite <= '1';
                            FlagsWrite <= '0';
                            PCSrc <= "00";
                            PCWrite <= '1';
                            state <= S4d;
                        elsif (S_L = '1') then
                            IRWrite <= '0';
                            RegWrite <= '0';
                            MAWrite <= '0';
                            MemWrite <= '0';
                            FlagsWrite <= '0';
                            PCSrc <= "00";
                            PCWrite <= '0';
                            state <= S3;
                        else 
                            IRWrite <= '1';
                            RegWrite <= '0';
                            MAWrite <= '0';
                            MemWrite <= '0';
                            FlagsWrite <= '0';
                            PCSrc <= "00";
                            PCWrite <= '0';
                            state <= S0;
                        end if;
                    when S2b =>
                        if (S_L = '0' and Rd /= "1111") then
                            IRWrite <= '0';
                            RegWrite <= '1';
                            MAWrite <= '0';
                            MemWrite <= '0';
                            FlagsWrite <= '0';
                            PCSrc <= "00";
                            PCWrite <= '1';
                            state <= S4a;
                        elsif (S_L = '0' and Rd = "1111") then
                            IRWrite <= '0';
                            RegWrite <= '0';
                            MAWrite <= '0';
                            MemWrite <= '0';
                            FlagsWrite <= '0';
                            PCSrc <= "10";
                            PCWrite <= '1';
                            state <= S4b;
                        elsif (S_L = '1' and Rd /= "1111") then 
                            IRWrite <= '0';
                            RegWrite <= '1';
                            MAWrite <= '0';
                            MemWrite <= '0';
                            FlagsWrite <= '1';
                            PCSrc <= "00";
                            PCWrite <= '1';
                            state <= S4e;
                        elsif (S_L = '1' and Rd = "1111") then
                            IRWrite <= '0';
                            RegWrite <= '0';
                            MAWrite <= '0';
                            MemWrite <= '0';
                            FlagsWrite <= '1';
                            PCSrc <= "10";
                            PCWrite <= '1';
                            state <= S4f;
                        else 
                            IRWrite <= '1';
                            RegWrite <= '0';
                            MAWrite <= '0';
                            MemWrite <= '0';
                            FlagsWrite <= '0';
                            PCSrc <= "00";
                            PCWrite <= '0';
                            state <= S0;
                        end if;
                    when S3 =>
                        if (Rd /= "1111") then
                            IRWrite <= '0';
                            RegWrite <= '1';
                            MAWrite <= '0';
                            MemWrite <= '0';
                            FlagsWrite <= '0';
                            PCSrc <= "00";
                            PCWrite <= '1';
                            state <= S4a;
                        elsif (Rd = "1111") then
                            IRWrite <= '0';
                            RegWrite <= '0';
                            MAWrite <= '0';
                            MemWrite <= '0';
                            FlagsWrite <= '0';
                            PCSrc <= "10";
                            PCWrite <= '1';
                            state <= S4b;
                        else 
                            IRWrite <= '1';
                            RegWrite <= '0';
                            MAWrite <= '0';
                            MemWrite <= '0';
                            FlagsWrite <= '0';
                            PCSrc <= "00";
                            PCWrite <= '0';
                            state <= S0;
                        end if;
                    when S4a =>
                        IRWrite <= '1';
                        RegWrite <= '0';
                        MAWrite <= '0';
                        MemWrite <= '0';
                        FlagsWrite <= '0';
                        PCSrc <= "00";
                        PCWrite <= '0';
                        state <= S0;
                    when S4b =>
                        IRWrite <= '1';
                        RegWrite <= '0';
                        MAWrite <= '0';
                        MemWrite <= '0';
                        FlagsWrite <= '0';
                        PCSrc <= "00";
                        PCWrite <= '0';
                        state <= S0;
                    when S4c =>
                        IRWrite <= '1';
                        RegWrite <= '0';
                        MAWrite <= '0';
                        MemWrite <= '0';
                        FlagsWrite <= '0';
                        PCSrc <= "00";
                        PCWrite <= '0';
                        state <= S0;
                    when S4d =>
                        IRWrite <= '1';
                        RegWrite <= '0';
                        MAWrite <= '0';
                        MemWrite <= '0';
                        FlagsWrite <= '0';
                        PCSrc <= "00";
                        PCWrite <= '0';
                        state <= S0;
                    when S4e =>
                        IRWrite <= '1';
                        RegWrite <= '0';
                        MAWrite <= '0';
                        MemWrite <= '0';
                        FlagsWrite <= '0';
                        PCSrc <= "00";
                        PCWrite <= '0';
                        state <= S0;
                    when S4f =>
                        IRWrite <= '1';
                        RegWrite <= '0';
                        MAWrite <= '0';
                        MemWrite <= '0';
                        FlagsWrite <= '0';
                        PCSrc <= "00";
                        PCWrite <= '0';
                        state <= S0;
                    when S4g =>
                        IRWrite <= '1';
                        RegWrite <= '0';
                        MAWrite <= '0';
                        MemWrite <= '0';
                        FlagsWrite <= '0';
                        PCSrc <= "00";
                        PCWrite <= '0';
                        state <= S0;
                    when S4h =>
                        IRWrite <= '1';
                        RegWrite <= '0';
                        MAWrite <= '0';
                        MemWrite <= '0';
                        FlagsWrite <= '0';
                        PCSrc <= "00";
                        PCWrite <= '0';
                        state <= S0;
                    when others =>
                        IRWrite <= '1';
                        RegWrite <= '0';
                        MAWrite <= '0';
                        MemWrite <= '0';
                        FlagsWrite <= '0';
                        PCSrc <= "00";
                        PCWrite <= '0';
                        state <= S0;
                end case;
            end if;
        end if;
    end process; 

    states <= state;
    
end Behavioral;
