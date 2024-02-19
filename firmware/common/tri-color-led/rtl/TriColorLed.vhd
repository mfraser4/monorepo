library ieee;
use ieee.std_logic_1164.all;

library mf;
use mf.TriColorLedPkg.all;
use mf.TriColorLedRaw;
use mf.PwmPkg.all;

--!
--! @brief      Tri-color LED module that maps the input color to RGB signals.
--!
--! @todo       Refactor RGB signals into a record type.
--! @todo       Refactor RGB duty cycle signals into a record type.
--!
entity TriColorLed is
    generic (
        --! @brief Pass-through for @ref Pwm.COUNTS_PER_PERIOD. Defaults to
        --!        an period of 100Hz with a 100MHz clock.
        --!
        COUNTS_PER_PERIOD : integer := 1000000
    );
    Port (
        --! Input clock.
        i_clk : in std_logic;

        --! Color to display on the LED
        i_color : in Color;

        --! o_red Red pin of the LED.
        o_red : out std_logic;


        --! Green pin of the LED.
        o_green : out std_logic;

        --! Blue pin of the LED.
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
