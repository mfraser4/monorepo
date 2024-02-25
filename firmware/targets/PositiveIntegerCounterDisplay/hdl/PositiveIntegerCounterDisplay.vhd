library ieee;
use ieee.std_logic_1164.all;

library mf;
use mf.SegmentDisplay8DigitUnsignedInt;

library surf;
use surf.RegisterVector;
use surf.StdRtlPkg.all;

entity PositiveIntegerCounterDisplay is
    Port ( CLK100MHZ : in sl;
           CPU_RESETN : in sl;
           AN : out slv (7 downto 0);
           CA : out slv (7 downto 0)
         );
end PositiveIntegerCounterDisplay;

architecture Behavioral of PositiveIntegerCounterDisplay is

    signal counter : positive range 0 to 999999 := 0;
    signal cur_val : positive range 0 to 99999999 := 0;
    signal rst : boolean;

begin

    -- CPU_RESETN is active-low, so invert for boolean logic
    rst <= not toBoolean(CPU_RESETN);

display:
    entity SegmentDisplay8DigitUnsignedInt
    port map (
        clk => CLK100MHZ,
        rst => rst,
        val => cur_val,
        anodes => AN,
        cathodes => CA
    );

INCREMENTER:
    process(CLK100MHZ, CPU_RESETN, cur_val)
    begin
        if (rst) then
            cur_val <= 0;
            counter <= 0;
        elsif rising_edge(CLK100MHZ) then
            if counter >= 999999 then
                counter <= 0;
                cur_val <= cur_val + 1;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

end Behavioral;
