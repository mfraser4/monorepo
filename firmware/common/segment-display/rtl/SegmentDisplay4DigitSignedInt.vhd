library ieee;
use ieee.std_logic_1164.all;

library mf;
use mf.SegmentDisplayPkg.all;

--!
--! @brief Segment display driver for base-10 integers in the range of -999 to
--! 999 using four (4) anodes.
--!
--! @param[in] clk 100MHz clock reference
--! @param[in] val Value to write to the analog display. Any updates to \c val
--!                will propagate to the analog display
--! @param[out] anodes Anodes of the display (0 and 3 being least and most
--!                    significant, respectively)
--! @param[out] cathode Cathodes of the display (0 to 7, in order, CA-CG and DP)
--!
entity SegmentDisplay4DigitSignedInt is
    Port (
        clk : in std_logic;
        val : in integer range -999 to 999;
        anodes : out std_logic_vector (3 downto 0);
        cathodes : out std_logic_vector (7 downto 0)
    );
end SegmentDisplay4DigitSignedInt;

architecture Behavioral of SegmentDisplay4DigitSignedInt is

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
                anodes <= (others => INACTIVE);
                anodes(cur_an) <= ACTIVE;

                -- Get the number value at cur_an in base 10 (e.g. val of 123
                -- at cur_an = 1 is a value of 2)
                -- NOTE: The last anode is reserved for the signedness of val
                case cur_an is
                    when 0 => anode_val <= abs(val) mod 10;
                    when 1 => anode_val <= abs(val / 10) mod 10;
                    when 2 => anode_val <= abs(val / 100) mod 10;
                    when others => null;
                end case;
            elsif (counter = 1) then
                -- The last anode is reserved for the signedness of val
                if (cur_an = (anodes'length-1)) then
                    -- negative sign or nothing
                    if (val < 0) then
                        cathodes <= CA_NEG;
                    else
                        cathodes <= CA_OFF;
                    end if;
                else
                    cathodes <= DigitToCathode(anode_val);
                end if;
            end if;

            -- Reset if we've reached the millisecond mark
            if (counter >= CYCLES_PER_MS) then
                counter <= 0;
                cur_an <= (cur_an + 1) mod anodes'length;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
end Behavioral;
