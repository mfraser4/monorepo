library ieee;
use ieee.std_logic_1164.all;

library mf;
use mf.disp_8_signed_int;

entity PositiveIntegerCounterDisplay is
    Port ( CLK100MHZ : in STD_LOGIC;
           CPU_RESETN : in STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           CA : out STD_LOGIC_VECTOR (7 downto 0)
         );
end PositiveIntegerCounterDisplay;

architecture Behavioral of PositiveIntegerCounterDisplay is

    signal counter : integer range 0 to 999999 := 0;
    signal cur_val : integer range 0 to 9999999 := 0;

begin

display:
    entity disp_8_signed_int
    port map (
        clk => CLK100MHZ,
        val => cur_val,
        anodes => AN,
        cathodes => CA
    );

INCREMENTER:
    process(CLK100MHZ, CPU_RESETN, cur_val)
    begin
        if rising_edge(CLK100MHZ) then
            if CPU_RESETN = '0' then
                cur_val <= 0;
                counter <= 0;
            elsif counter >= 999999 then
                counter <= 0;
                cur_val <= cur_val + 1;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

end Behavioral;
