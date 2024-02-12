library ieee;
use ieee.std_logic_1164.all;

package segment_display is

    -- Active and inactive signals for the 7-segment display (active low)
    constant ACTIVE : std_logic := '0';
    constant INACTIVE : std_logic := not ACTIVE;

    -- Numeric values as cathode signals                  PGFEDCBA
    constant CA_OFF   : std_logic_vector (7 downto 0) := "11111111";
    constant CA_ZERO  : std_logic_vector (7 downto 0) := "11000000";
    constant CA_ONE   : std_logic_vector (7 downto 0) := "11111001";
    constant CA_TWO   : std_logic_vector (7 downto 0) := "10100100";
    constant CA_THREE : std_logic_vector (7 downto 0) := "10110000";
    constant CA_FOUR  : std_logic_vector (7 downto 0) := "10011001";
    constant CA_FIVE  : std_logic_vector (7 downto 0) := "10010010";
    constant CA_SIX   : std_logic_vector (7 downto 0) := "10000010";
    constant CA_SEVEN : std_logic_vector (7 downto 0) := "11111000";
    constant CA_EIGHT : std_logic_vector (7 downto 0) := "10000000";
    constant CA_NINE  : std_logic_vector (7 downto 0) := "10011000";
    constant CA_NEG   : std_logic_vector (7 downto 0) := "10111111";
    constant CA_ERROR : std_logic_vector (7 downto 0) := "10010010";

    subtype Digit is integer range 0 to 9;

    --!
    --! @brief Extracts the integer from the ith position of i_val
    --!
    --! @param i_val Value from which to extract the integer
    --! @param i_pos Position of the integer (0 being least significant digit)
    --!
    --! @return The ith digit of i_val
    function GetDigitFrom8Int (
        i_val : integer range 0 to 99999999;
        i_pos : integer range 0 to 7
        ) return Digit;

    --!
    --! @brief Converts a numeric digit to a range of cathode signals.
    --!
    --! @param i_digit Digit to convert to cathode signals
    --!
    --! @return Array of cathode signals in the order (most significant to least
    --! significant order) of [DP, CG, CF, CE, CD, CC, CB, CA].
    function DigitToCathode (
        i_digit : Digit
        ) return std_logic_vector;

end package segment_display;

package body segment_display is

    function GetDigitFrom8Int (
        i_val : integer range 0 to 99999999;
        i_pos : integer range 0 to 7
        )
        return Digit is
    begin
        case i_pos is
            when 0 => return i_val mod 10;
            when 1 => return (i_val / 10) mod 10;
            when 2 => return (i_val / 100) mod 10;
            when 3 => return (i_val / 1000) mod 10;
            when 4 => return (i_val / 10000) mod 10;
            when 5 => return (i_val / 100000) mod 10;
            when 6 => return (i_val / 1000000) mod 10;
            when 7 => return (i_val / 10000000) mod 10;
        end case;
    end;

    function DigitToCathode (
        i_digit : Digit
        )
        return std_logic_vector is
    begin
        case i_digit is
            when 0 => return CA_ZERO;
            when 1 => return CA_ONE;
            when 2 => return CA_TWO;
            when 3 => return CA_THREE;
            when 4 => return CA_FOUR;
            when 5 => return CA_FIVE;
            when 6 => return CA_SIX;
            when 7 => return CA_SEVEN;
            when 8 => return CA_EIGHT;
            when 9 => return CA_NINE;
            when others => return CA_ERROR;
        end case;
    end;


end package body segment_display;
