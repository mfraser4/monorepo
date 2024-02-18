library ieee;
use ieee.std_logic_1164.all;

library mf;
use mf.TriColorLed;
use mf.TriColorLedPkg.all;

entity TriColorLedSwitches is
    Port (
        CLK100MHZ : in std_logic;

        -- Color switches
        SW_LED16 : in std_logic_vector (5 downto 0);
        SW_LED17 : in std_logic_vector (5 downto 0);

        -- Tri-color LED16
        LED16_B : out std_logic;
        LED16_G : out std_logic;
        LED16_R : out std_logic;

        -- Tri-color LED17
        LED17_B : out std_logic;
        LED17_G : out std_logic;
        LED17_R : out std_logic;

        -- Switch LEDs to show which switch/es are selected
        LED : out std_logic_vector (11 downto 0)
    );
end TriColorLedSwitches;

architecture Behavioral of TriColorLedSwitches is

    signal color_led16: Color := RED;
    signal color_led17: Color := GREEN;

begin

    LED (11 downto 6) <= SW_LED17;
    LED (5 downto 0) <= SW_LED16;

led16:
    entity TriColorLed
    port map (
        i_clk => CLK100MHZ,
        i_color => color_led16,
        o_red => LED16_R,
        o_green => LED16_G,
        o_blue => LED16_B
    );

led17:
    entity TriColorLed
    port map (
        i_clk => CLK100MHZ,
        i_color => color_led17,
        o_red => LED17_R,
        o_green => LED17_G,
        o_blue => LED17_B
    );

main:
    process(CLK100MHZ, SW_LED16, SW_LED17)
    begin
        if rising_edge(CLK100MHZ) then
            case(SW_LED16) is
                when "000001" => color_led16 <= RED;
                when "000010" => color_led16 <= ORANGE;
                when "000100" => color_led16 <= YELLOW;
                when "001000" => color_led16 <= GREEN;
                when "010000" => color_led16 <= BLUE;
                when "100000" => color_led16 <= PURPLE;
                when others => color_led16 <= NONE;
            end case;

            case(SW_LED17) is
                when "000001" => color_led17 <= RED;
                when "000010" => color_led17 <= ORANGE;
                when "000100" => color_led17 <= YELLOW;
                when "001000" => color_led17 <= GREEN;
                when "010000" => color_led17 <= BLUE;
                when "100000" => color_led17 <= PURPLE;
                when others => color_led17 <= NONE;
            end case;
        end if;
    end process;

end Behavioral;
