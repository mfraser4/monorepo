library ieee;
use ieee.std_logic_1164.all;

--!
--! @brief Module for displaying 8 digits on a 7-segment anode display
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
entity disp_8_signed_int is
    Port (
        clk : in std_logic;
        val : in integer range 0 to 9999999;
        anodes : out std_logic_vector (7 downto 0);
        cathodes : out std_logic_vector (7 downto 0)
    );
end disp_8_signed_int;

architecture Behavioral of disp_8_signed_int is

    -- Cycles per millisecond with a 100MHz clock and triggering on the rising
    -- edge (0 index start)
    constant CYCLES_PER_MS : integer range 0 to 99999 := 99999;

    -- Anodes and cathodes are active low
    constant AN_ACTIVE, C_ACTIVE : std_logic := '0';
    constant AN_INACTIVE, C_INACTIVE : std_logic := '1';

    -- Internal triggers and variables
    signal counter : integer range 0 to CYCLES_PER_MS := 0;
    signal cur_an : integer range 0 to (anodes'length - 1) := 0;
    signal anode_val : integer range 0 to 9 := 0;

begin

COUNT_PER_CLOCK:
    process(clk)
    begin
        if rising_edge(clk) then
            -- State machine
            if (counter = 0) then
                -- Rotate anodes and illuminate the next anode in the cycle
                anodes <= (others => AN_INACTIVE);
                anodes(cur_an) <= AN_ACTIVE;

                -- Get the number value at cur_an in base 10 (e.g. val of 123
                -- at cur_an = 1 is a value of 2)
                -- NOTE: The last anode is reserved for the signedness of val
                case cur_an is
                    when 0 => anode_val <= (val) mod 10;
                    when 1 => anode_val <= (val / 10) mod 10;
                    when 2 => anode_val <= (val / 100) mod 10;
                    when 3 => anode_val <= (val / 1000) mod 10;
                    when 4 => anode_val <= (val / 10000) mod 10;
                    when 5 => anode_val <= (val / 100000) mod 10;
                    when 6 => anode_val <= (val / 1000000) mod 10;
                    when others => null;
                end case;

                counter <= counter + 1;
            elsif (counter = 1) then
                -- Display the digit value by driving the cathodes
                case anode_val is
                    --                     PGFEDCBA
                    when 0 => cathodes <= "11000000";
                    when 1 => cathodes <= "11111001";
                    when 2 => cathodes <= "10100100";
                    when 3 => cathodes <= "10110000";
                    when 4 => cathodes <= "10011001";
                    when 5 => cathodes <= "10010010";
                    when 6 => cathodes <= "10000010";
                    when 7 => cathodes <= "11111000";
                    when 8 => cathodes <= "10000000";
                    when 9 => cathodes <= "10011000";
                end case;

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
