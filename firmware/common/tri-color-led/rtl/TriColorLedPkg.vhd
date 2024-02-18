library ieee;
use ieee.std_logic_1164.all;

package TriColorLedPkg is

    type Color is (NONE, RED, ORANGE, YELLOW, GREEN, BLUE, PURPLE);

    function toRed ( color : Color ) return integer;
    function toGreen ( color : Color ) return integer;
    function toBlue ( color : Color ) return integer;

end package TriColorLedPkg;

package body TriColorLedPkg is

    -- Everything is divided by two due to Digilent recommending not running the
    -- LED any heavier than 50% duty cycle due to its brightness.
    function toRed ( color : Color ) return integer is
    begin
        case(color) is
            when RED => return 100 / 2;
            when ORANGE => return 40 / 2;
            when YELLOW => return 10 / 2;
            when GREEN => return 0;
            when BLUE => return 0;
            when PURPLE => return 25 / 2;
            when others => return 0;
        end case;
    end function toRed;

    function toGreen ( color : Color ) return integer is
    begin
        case(color) is
            when RED => return 0;
            when ORANGE => return 10 / 2;
            when YELLOW => return 40 / 2;
            when GREEN => return 100 / 2;
            when BLUE => return 0;
            when PURPLE => return 0;
            when others => return 0;
        end case;
    end function toGreen;

    function toBlue ( color : Color ) return integer is
    begin
        case(color) is
            when RED => return 0;
            when ORANGE => return 0;
            when YELLOW => return 0;
            when GREEN => return 0;
            when BLUE => return 100 / 2;
            when PURPLE => return 25 / 2;
            when others => return 0;
        end case;
    end function toBlue;

end package body TriColorLedPkg;
