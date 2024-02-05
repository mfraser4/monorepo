library ieee;
use ieee.std_logic_1164.all;

library mf;
use mf.cathodes.all;

--!
--! @brief      Writes \c val to the cathode outputs. This is effectively a
--!             singleton, as there should only be one driver of the cathodes,
--!             and this entity is intended to be used with a higher-level
--!             cathode/anode controller.
--!
--! @param[in] val Integer to write to the display.
--! @param[out] cathodes Display cathodes (0 to 7, in order, CA-CG and DP)
--!
--! @todo Future improvement to do hexadecimal-based display.
--!
entity write_cathodes is
    Port (
        val : in integer range 0 to 9;
        cathodes : out std_logic_vector (7 downto 0)
    );
end write_cathodes;

architecture Behavioral of write_cathodes is

begin

WRITE_VAL:
    process(val)
    begin
        case val is
            --                        PGFEDCBA
            -- when DV_NIL => cathodes <= "10111111";
            -- when DV_0 => cathodes <= "11000000";
            -- when DV_1 => cathodes <= "11111001";
            -- when DV_2 => cathodes <= "10100100";
            -- when DV_3 => cathodes <= "10110000";
            -- when DV_4 => cathodes <= "10011001";
            -- when DV_5 => cathodes <= "10010010";
            -- when DV_6 => cathodes <= "10000010";
            -- when DV_7 => cathodes <= "11111000";
            -- when DV_8 => cathodes <= "10000000";
            -- when DV_9 => cathodes <= "10011000";
            -- when DV_A => cathodes <= "10001000";
            -- when DV_C => cathodes <= "11000110";
            -- when DV_E => cathodes <= "10000110";
            -- when DV_F => cathodes <= "10001110";

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
    end process;
end Behavioral;
