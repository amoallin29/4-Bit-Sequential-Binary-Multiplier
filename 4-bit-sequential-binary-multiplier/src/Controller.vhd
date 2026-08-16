library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Controller is
    generic (N: integer := 2);
    Port ( Clk : in  STD_LOGIC;
           Q0 : in  STD_LOGIC;
           C4 : in  STD_LOGIC;
           Start : in  STD_LOGIC;
           Load : out  STD_LOGIC;
           Shift : out  STD_LOGIC;
           AddA : out  STD_LOGIC;
           Done : out  STD_LOGIC);
end Controller;

architecture Behavioral of Controller is
    type states is (InitS, LoadS, AddS, ShiftS, DoneS);
    signal state: states := InitS;
begin
    Done  <= '1' when state = InitS or state = DoneS else '0';
    Load  <= '1' when state = LoadS else '0';
    AddA  <= '1' when state = AddS else '0';
    Shift <= '1' when state = ShiftS else '0';

    process(Clk)
    begin
        if falling_edge(Clk) then
            case state is
                -- InitS waits for Start
                when InitS =>
                    if Start = '1' then
                        state <= LoadS;
                    else
                        state <= InitS;
                    end if;

                -- InitS loads the multiplier and multiplicand regs
                -- controller checks current multiplier
                when LoadS =>
                    if Q0 = '1' then
                        state <= AddS;
                    else
                        state <= ShiftS;
                    end if;

                -- AddS loads adder result into accumulator
                when AddS =>
                    state <= ShiftS;

                -- ShiftS shifts the accumulator and multiplier regs
                -- if C4 is high, the multiplier bits are processed
                when ShiftS =>
                    if C4 = '1' then
                        state <= DoneS;
                    elsif Q0 = '1' then
                        state <= AddS;
                    else
                        state <= ShiftS;
                    end if;

                -- DoneS holds done high until start goes low
                when DoneS =>
                    if Start = '0' then
                        state <= InitS;
                    else
                        state <= DoneS;
                    end if;
            end case;
        end if;
    end process;
end Behavioral;
