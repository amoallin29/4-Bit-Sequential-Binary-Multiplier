library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CounterN is
    generic (N : integer := 3);
    port ( Clk : in STD_LOGIC;
           Clear : in STD_LOGIC;
           Enable : in STD_LOGIC;
           C4 : out STD_LOGIC);
end CounterN;

architecture Behavioral of CounterN is
    -- internal counter sig
    -- N=3 gives a 3-bit counter, can count up to 4
    signal Count : unsigned(N-1 downto 0) := (others => '0');
begin
    process(Clk)
    begin
        if rising_edge(Clk) then
            -- clear the counter at start of multiplication
            if Clear = '1' then
                Count <= (others => '0');
            elsif Enable = '1' then
                Count <= Count + 1;
            end if;
        end if;
    end process;

    -- C4 becomes high after 4 shift cycles
    C4 <= '1' when Count = to_unsigned(4,N) else '0';
end Behavioral;
