library ieee;
use ieee.std_logic_1164.all;

library mf;
use mf.Pwm;
use mf.PwmPkg.DUTY_MAX;

entity TriColorLedRaw is
    generic (
        --! @brief Pass-through for @ref Pwm.COUNTS_PER_PERIOD. Defaults to
        --!        an period of 100Hz with a 100MHz clock.
        --!
        COUNTS_PER_PERIOD : integer := 1000000
    );
    Port (
        i_clk : in std_logic;
        i_duty_red : in integer range 0 to DUTY_MAX;
        i_duty_green : in integer range 0 to DUTY_MAX;
        i_duty_blue : in integer range 0 to DUTY_MAX;
        o_red : out std_logic;
        o_green : out std_logic;
        o_blue : out std_logic
    );
end TriColorLedRaw;

architecture Behavioral of TriColorLedRaw is

begin

red_pwm:
    entity Pwm
    generic map (COUNTS_PER_PERIOD => COUNTS_PER_PERIOD)
    port map (
        i_clk => i_clk,
        i_duty => i_duty_red,
        o_signal => o_red
    );

green_pwm:
    entity Pwm
    generic map (COUNTS_PER_PERIOD => COUNTS_PER_PERIOD)
    port map (
        i_clk => i_clk,
        i_duty => i_duty_green,
        o_signal => o_green
    );

blue_pwm:
    entity Pwm
    generic map (COUNTS_PER_PERIOD => COUNTS_PER_PERIOD)
    port map (
        i_clk => i_clk,
        i_duty => i_duty_blue,
        o_signal => o_blue
    );

end Behavioral;
