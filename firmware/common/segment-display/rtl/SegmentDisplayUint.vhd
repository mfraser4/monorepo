library ieee;
use ieee.std_logic_1164.all;

library mf;
use mf.SegmentDisplayPkg.all;

library surf;
use surf.StdRtlPkg.all;

--!
--! @brief Module for displaying a base-10 unsigned integer on a 7-segment anode
--! display.
--!
--! @description This module is designed to be utilized with anode displays like
--! the ones described in
--! https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual.
--!
--! @todo Negative numbers are currently not supported.
--!
--! @param[in] clk 100MHz clock reference
--! @param[in] rst If @c true, reset to initial state.
--! @param[in] val Value to write to the analog display. Any updates to \c val
--!                will propagate to the analog display.
--! @param[out] anodes Anodes of the display (0 and 3 being least and most
--!                    significant, respectively).
--! @param[out] cathode Display cathodes (0 to 7, in order, CA-CG and DP).
--!
entity SegmentDisplayUint is
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
        rst : in boolean;
        val : in natural range 0 to (10**ANODES_LENGTH - 1);
        anodes : out slv ((ANODES_LENGTH - 1) downto 0);
        cathodes : out slv (7 downto 0)
    );
end SegmentDisplayUint;

architecture Behavioral of SegmentDisplayUint is

   --! Calculate clock period based on clock frequency
    constant CLK_PERIOD_NS : time := 1.0 sec / real(CLK_FREQUENCY_HZ);

    --! Cycles per millisecond based on clock period
    constant CYCLES_PER_MS : positive := positive(1000.0 ns / CLK_PERIOD_NS);

    -- Internal triggers and variables
    signal counter : natural range 0 to CYCLES_PER_MS := 0;
    signal cur_an : natural range 0 to (ANODES_LENGTH - 1) := 0;
    signal anode_digits : array ((ANODES_LENGTH - 1) downto 0) of Digit := (others => 0);

begin

    --!
    --! @brief      Updates the array of anode digits whenever @c val updates.
    --!
    --! As an example, if @c val were @c 123, then @c anode_digits would update
    --! to @c{[1, 2, 3]}.
    --!
    --! @param      val   The number to display.
    --!
    update_digit_array : process(val)
    begin
        for i in (ANODES_LENGTH - 1) downto 0 loop
            anode_digits(i) <= ExtractDigit(val, i);
        end loop;
    end process update_digit_array;

    --!
    --! @brief      Main process for displaying @c val.
    --!
    --! @param      clk   The clock
    --!
    comb : process(clk)
    begin
        if rst then
            anode_digits <= (others => 0);
            counter <= 0;
            cur_an <= 0;
        elsif rising_edge(clk) then
            -- State machine
            if (counter = 0) then
                -- Rotate anodes and illuminate the next anode in the cycle
                anodes <= (others => INACTIVE);
                anodes(cur_an) <= ACTIVE;
                counter <= counter + 1;
            elsif (counter = 1) then
                cathodes <= DigitToCathode(anode_digits(cur_an));
                --cathodes <= DigitToCathode(5);
                counter <= counter + 1;
            elsif (counter >= CYCLES_PER_MS) then
                -- Reset if we've reached the millisecond mark
                counter <= 0;
                cur_an <= (cur_an + 1) mod ANODES_LENGTH;
            else
                -- Continually illuminate current anode
                counter <= counter + 1;
            end if;
        end if;
    end process comb;
end Behavioral;
