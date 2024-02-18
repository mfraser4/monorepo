library ieee;
use ieee.std_logic_1164.all;

package PwmPkg is

    constant DUTY_MAX : integer := 100;

end package PwmPkg;

library ieee;
use ieee.std_logic_1164.all;

library mf;
use mf.PwmPkg.all;

--!
--! @brief A pulse-width modulation (PWM) module that can drive signals with a
--!        configurable period. A duty value of 0 will hold @ref o_signal at
--!        @c '0'.
--!
--! @param[in] i_clk Input clock.
--! @param[in] i_duty Duty cycle. Valid values are between 0 to 1.
--! @param[out] o_signal Output signal driven by the PWM module.
--!
entity Pwm is
    generic (
        --! Duty period in clock cycle counts. Default is 1sec with a 100MHz
        --! clock.
        --!
        COUNTS_PER_PERIOD : integer := 1000000000
    );
    Port (
        i_clk : in std_logic;
        i_duty : in integer range 0 to DUTY_MAX;
        o_signal : out std_logic
    );
end Pwm;

architecture Behavioral of Pwm is

    signal counter : integer range 0 to (COUNTS_PER_PERIOD - 1) := 0;
    signal cycles_per_duty : integer range 0 to (COUNTS_PER_PERIOD - 1) := 0;

begin

MAIN:
    process(i_clk, i_duty)
    begin
        if rising_edge(i_clk) then
            if (i_duty = 0) then
                o_signal <= '0';
            else
                if (counter < cycles_per_duty) then
                    -- Active period of the duty cycle
                    o_signal <= '1';
                    counter <= counter + 1;
                elsif (counter < COUNTS_PER_PERIOD) then
                    -- Inactive period of the duty cycle
                    o_signal <= '0';
                    counter <= counter + 1;
                else
                    -- Reset duty cycle
                    counter <= 0;
                end if;

                cycles_per_duty <= COUNTS_PER_PERIOD / (101 - i_duty);
            end if;
        end if;

    end process;

end Behavioral;

