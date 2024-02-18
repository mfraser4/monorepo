library ieee;
use ieee.std_logic_1164.all;

library mf;
use mf.TriColorLedPkg.all;
use mf.TriColorLedRaw;
use mf.PwmPkg.all;

entity TriColorLed is
    generic (
        --! @brief Pass-through for @ref Pwm.COUNTS_PER_PERIOD. Defaults to
        --!        an period of 100Hz with a 100MHz clock.
        --!
        COUNTS_PER_PERIOD : integer := 1000000
    );
    Port (
        i_clk : in std_logic;
        i_color : in Color;
        o_red : out std_logic;
        o_green : out std_logic;
        o_blue : out std_logic
    );
end TriColorLed;

architecture Behavioral of TriColorLed is

    signal duty_red: integer range 0 to DUTY_MAX := 0;
    signal duty_green: integer range 0 to DUTY_MAX := 0;
    signal duty_blue: integer range 0 to DUTY_MAX := 0;

begin

tri_color_led_raw:
    entity TriColorLedRaw
    generic map (COUNTS_PER_PERIOD => COUNTS_PER_PERIOD)
    port map (
        i_clk => i_clk,
        i_duty_red => duty_red,
        i_duty_green => duty_green,
        i_duty_blue => duty_blue,
        o_red => o_red,
        o_green => o_green,
        o_blue => o_blue
    );

MAIN:
    process(i_clk, i_color)
    begin
        if rising_edge(i_clk) then
            duty_red <= toRed(i_color);
            duty_green <= toGreen(i_color);
            duty_blue <= toBlue(i_color);
        end if;
    end process;

end Behavioral;
