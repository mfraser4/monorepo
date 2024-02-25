library ieee;
use ieee.std_logic_1164.all;

library mf;
use mf.SegmentDisplayPkg.all;

library surf;
use surf.StdRtlPkg.all;

entity SegmentDisplay8BitStdVector is
    generic (
        --! Default number of anodes for a segment display
        ANODES_LENGTH : positive := 8;

        --! Default clock frequency in Hz (e.g., 100 MHz)
        CLK_FREQUENCY_HZ : positive := 100000000;

        --! Default clock edge sensitivity (e.g., rising edge)
        CLK_EDGE : sl := '1'
    );
    Port (
        clk : in sl;
        val : in slv (7 downto 0);
        anodes : out slv ((ANODES_LENGTH - 1) downto 0);
        cathodes : out slv (7 downto 0)
    );
end SegmentDisplay8BitStdVector;

architecture Behavioral of SegmentDisplay8BitStdVector is

   --! Calculate clock period based on clock frequency
    constant CLK_PERIOD_NS : time := 1.0 sec / real(CLK_FREQUENCY_HZ);

    --! Cycles per millisecond based on clock period
    constant CYCLES_PER_MS : integer := integer(1000.0 ns / CLK_PERIOD_NS);

    -- Internal triggers and variables
    signal counter : natural range 0 to CYCLES_PER_MS := 0;
    signal cur_an : natural range 0 to (ANODES_LENGTH - 1) := 0;
    signal anode_val : Digit := 0;

begin

COUNT_PER_CLOCK:
    process(clk)
    begin
        if rising_edge(clk) then
            -- State machine
            if (counter = 0) then
                -- Rotate anodes and illuminate the next anode in the cycle
                anodes <= (others => INACTIVE);
                anodes(cur_an) <= ACTIVE;
                counter <= counter + 1;
            elsif (counter = 1) then
                if (val(cur_an) = '0') then
                    cathodes <= CA_ZERO;
                elsif (val(cur_an) = '1') then
                    cathodes <= CA_ONE;
                else
                    -- Cathode value is indeterminate
                    cathodes <= CA_ERROR;
                end if;

                counter <= counter + 1;
            elsif (counter >= CYCLES_PER_MS) then
                -- Reset if we've reached the millisecond mark
                counter <= 0;
                cur_an <= (cur_an + 1) mod anodes'length;
            else
                -- Continually illuminate current anode
                counter <= counter + 1;
            end if;
        end if;
    end process;
end Behavioral;
