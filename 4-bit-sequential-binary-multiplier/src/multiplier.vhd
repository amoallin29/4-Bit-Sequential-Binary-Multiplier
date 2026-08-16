library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MULTTOP is
    Port ( Multiplier : in  STD_LOGIC_VECTOR (3 downto 0);
           Multiplicand : in  STD_LOGIC_VECTOR (3 downto 0);
           Product : out  STD_LOGIC_VECTOR (7 downto 0);
           Start : in  STD_LOGIC;
           Done : out  STD_LOGIC;
           Clk : in  STD_LOGIC);
end MULTTOP;

architecture Behavioral of MULTTOP is
    component Controller
        generic (N: integer := 2);
        Port ( Clk : in  STD_LOGIC;
               Q0 : in  STD_LOGIC;
               C4 : in  STD_LOGIC;
               Start : in  STD_LOGIC;
               Load : out  STD_LOGIC;
               Shift : out  STD_LOGIC;
               AddA : out  STD_LOGIC;
               Done : out  STD_LOGIC);
    end component;

    component AdderN
        generic (N: integer := 4);
        port ( A: in std_logic_vector(N-1 downto 0);
               B: in std_logic_vector(N-1 downto 0);
               S: out std_logic_vector(N downto 0));
    end component;

    component RegN
        generic (N: integer := 4);
        port ( Din: in std_logic_vector(N-1 downto 0);
               Dout: out std_logic_vector(N-1 downto 0);
               Clk: in std_logic;
               Load: in std_logic;
               Shift: in std_logic;
               Clear: in std_logic;
               SerIn: in std_logic);
    end component;

    component CounterN
        generic (N: integer := 3);
        port ( Clk: in std_logic;
               Clear: in std_logic;
               Enable: in std_logic;
               C4: out std_logic);
    end component;

    signal Mout, Qout: std_logic_vector (3 downto 0);
    signal Dout, Aout: std_logic_vector (4 downto 0);
    signal Load, Shift, AddA, C4: std_logic;
begin
    C: Controller generic map (2)
                  port map (Clk, Qout(0), C4, Start, Load, Shift, AddA, Done);

    A: AdderN generic map (4)
              port map (Aout(3 downto 0), Mout, Dout);

    M: RegN generic map (4)
            port map (Multiplicand, Mout, Clk, Load, '0', '0', '0');

    Q: RegN generic map (4)
            port map (Multiplier, Qout, Clk, Load, Shift, '0', Aout(0));

    ACC: RegN generic map (5)
              port map (Dout, Aout, Clk, AddA, Shift, Load, '0');

    CNT: CounterN generic map (3)
                  port map (Clk, Load, Shift, C4);

    Product <= Aout(3 downto 0) & Qout;
end Behavioral;
