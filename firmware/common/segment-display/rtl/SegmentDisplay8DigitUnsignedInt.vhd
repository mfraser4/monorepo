library ieee;
use ieee.std_logic_1164.all;

library mf;
use mf.SegmentDisplayPkg.all;

--!
--! @brief Module for displaying a base-10 unsigned integer on a 7-segment anode
--! display from the range of 0 to 99999999 (8 anodes).
--!
--! @description This module is designed to be utilized with anode displays like
--! the ones described in
--! https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual.
--!
--! @todo Negative numbers are currently not supported.
--!
--! @param[in] clk 100MHz clock reference
--! @param[in] val Value to write to the analog display. Any updates to \c val
--!                will propagate to the analog display
--! @param[out] anodes Anodes of the display (0 and 3 being least and most
--!                    significant, respectively)
--! @param[out] cathode Cathodes of the display (0 to 7, in order, CA-CG and DP)
--!
entity SegmentDisplay8DigitUnsignedInt is
    Port (
        clk : in std_logic;
        val : in integer range 0 to 99999999;
        anodes : out std_logic_vector (7 downto 0);
        cathodes : out std_logic_vector (7 downto 0)
    );
end SegmentDisplay8DigitUnsignedInt;

architecture Behavioral of SegmentDisplay8DigitUnsignedInt is

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

                anode_val <= GetDigitFrom8Int(val, cur_an);
                counter <= counter + 1;
            elsif (counter = 1) then
                cathodes <= DigitToCathode(anode_val);
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
