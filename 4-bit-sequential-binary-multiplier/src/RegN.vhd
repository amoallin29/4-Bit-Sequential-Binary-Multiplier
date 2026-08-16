library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegN is
	generic (N: integer := 4);
	port (	Din: in std_logic_vector(N-1 downto 0);
				Dout: out std_logic_vector(N-1 downto 0);
				Clk: in std_logic;
				Load: in std_logic;
				Shift: in std_logic;
				Clear: in std_logic;
				SerIn: in std_logic
			);
end RegN;

architecture Behavioral of RegN is
	signal Dinternal: std_logic_vector(N-1 downto 0);
begin
	process(Clk)
	begin
		if (rising_edge(Clk)) then
			if (Clear = '1') then
				Dinternal <= (others => '0');
			elsif (Load = '1') then
				Dinternal <= Din;
			elsif (Shift = '1') then
				Dinternal <= SerIn & Dinternal(N-1 downto 1);
			end if;
		end if;
	end process;
	Dout <= Dinternal;
end Behavioral;
