library ieee;
use ieee.std_logic_1164.all;

library mf;
use mf.segment_display.all;

entity TemperatureSensorReader is
    Port ( CLK100MHZ : in STD_LOGIC;
           CPU_RESETN : in STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           CA : out STD_LOGIC_VECTOR (7 downto 0)
         );
end TemperatureSensorReader;

architecture Behavioral of TemperatureSensorReader is

    signal temperature : STD_LOGIC_VECTOR (15 downto 0);

begin

display:
    entity SegmentDisplay
    port map (
        clk => CLK100MHZ,
        val => temperature,
        anodes => AN,
        cathodes => CA
    );

end Behavioral;
