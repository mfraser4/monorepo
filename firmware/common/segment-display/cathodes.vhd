library mf;
package cathodes is

type DispVal is (
    DV_NIL, -- display nothing
    DV_NEG, -- negative sign
    DV_0,
    DV_1,
    DV_2,
    DV_3,
    DV_4,
    DV_5,
    DV_6,
    DV_7,
    DV_8,
    DV_9,
    DV_A,
--  DV_B, 7-segment displays cannot differentiate between 8 and B
    DV_C,
--  DV_D, 7-segment displays cannot differentiate between 0 and D
    DV_E,
    DV_F
);

end package ; -- cathodes
