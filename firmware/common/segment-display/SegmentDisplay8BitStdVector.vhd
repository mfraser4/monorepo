library ieee;
use ieee.std_logic_1164.all;

entity SegmentDisplay8BitStdVector is
    Port (
        clk : in std_logic;
        val : in std_logic_vector (7 downto 0);
        anodes : out std_logic_vector (3 downto 0);
        cathodes : out std_logic_vector (7 downto 0)
    );
end SegmentDisplay8BitStdVector;

architecture Behavioral of SegmentDisplay8BitStdVector is

    -- Cycles per millisecond with a 100MHz clock and triggering on the rising
    -- edge (0 index start)
    constant CYCLES_PER_MS : integer range 0 to 99999 := 99999;

    -- Internal triggers and variables
    signal counter : integer range 0 to CYCLES_PER_MS := 0;
    signal cur_an : integer range 0 to (anodes'length - 1) := 0;
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
