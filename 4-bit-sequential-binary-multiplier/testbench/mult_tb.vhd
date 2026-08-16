LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY mult_tb IS
END mult_tb;
 
ARCHITECTURE behavior OF mult_tb IS 

    COMPONENT MULTTOP
    PORT(
         Multiplier : IN  std_logic_vector(3 downto 0);
         Multiplicand : IN  std_logic_vector(3 downto 0);
         Product : OUT  std_logic_vector(7 downto 0);
         Start : IN  std_logic;
         Done : OUT  std_logic;
         Clk : IN  std_logic
        );
    END COMPONENT;
    
   --Inputs
   signal Multiplier : std_logic_vector(3 downto 0) := (others => '0');
   signal Multiplicand : std_logic_vector(3 downto 0) := (others => '0');
   signal Start : std_logic := '0';
   signal Clk : std_logic := '0';

 	--Outputs
   signal Product : std_logic_vector(7 downto 0);
   signal Done : std_logic;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MULTTOP PORT MAP (
          Multiplier => Multiplier,
          Multiplicand => Multiplicand,
          Product => Product,
          Start => Start,
          Done => Done,
          Clk => Clk
        );

	Clk <= not Clk after 10 ns;
 
   -- Stimulus process
   stim_proc: process
   begin
			for i in 15 downto 0 loop
				Multiplier <= std_logic_vector(to_unsigned(i,4));
				for j in 15 downto 0 loop
					Multiplicand <= std_logic_vector(to_unsigned(j,4));
					Start <= '0', '1' after 5 ns, '0' after 40 ns;
					wait for 50 ns;
					wait until Done = '1';
					assert(to_integer(UNSIGNED(Product))=(i*j))
						report "Incorrect product" severity NOTE;
					wait for 50 ns;
				end loop;
			end loop;
      wait;
   end process;
END;
