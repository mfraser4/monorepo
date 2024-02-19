library ieee;
use ieee.std_logic_1164.all;

library surf;
use surf.I2cPkg.all;
use surf.I2cMaster;

library mf;
use mf.SegmentDisplay;

entity TemperatureSensorReader is
    Port (
        CLK100MHZ : in STD_LOGIC;
        CPU_RESETN : in STD_LOGIC;

        -- Segment display anodes and cathodes
        AN : out STD_LOGIC_VECTOR (7 downto 0);
        CA : out STD_LOGIC_VECTOR (7 downto 0);

        -- Temperature sensor I2C pins
        TMP_SCL : inout STD_LOGIC;
        TMP_SDA : inout STD_LOGIC;

        -- Temperature sensor error signals
        TMP_INT : in STD_LOGIC;
        TMP_CT  : in STD_LOGIC;

        -- LEDs to display
        LED16_R : out STD_LOGIC;
        LED17_R : out STD_LOGIC
    );
end TemperatureSensorReader;

architecture Behavioral of TemperatureSensorReader is
    --! I2C slave address for the ADT7420 temperature sensor.
    --!
    constant ADT7420_I2C_SLAVE_ADDR : std_logic_vector (9 downto 0) := X"4B";

    --! I2C master (FPGA chip) input fields.
    --!
    signal i2cMasterIn : I2cMasterInType := (
        enable => '1',
        -- prescale => ?
        -- filter => ?
        -- txnReq => ?
        stop => '0',
        op => '0', -- read
        busReq => '0', -- read/write
        addr => ADT7420_I2C_SLAVE_ADDR
        -- tenbit => '0',
        -- wrValid => ?
        -- wrData => ?
        -- rdAck => ?
    );

    --! Output fields from the I2C slave (ADT7420)
    signal i2cMasterOut : I2cMasterOutType := (
        busAck => '0',
        txnError => '0',
        wrAck => '0',
        rdValid => '0',
        rdData => "00000000"
    );

    --! Two-byte register store for the last read temperature
    --!
    signal temperature : STD_LOGIC_VECTOR (15 downto 0);

begin

    -- Temperature signals are directly written to the LEDs for visibility of
    -- temperature sensor errors.
    LED16_R <= TMP_INT;
    LED17_R <= TMP_CT;

adt7420:
    entity I2cMaster
    port map (
        clk => CLK100MHZ,
        i2cMasterIn => i2cMasterIn,
        i2cMasterOut => i2cMasterOut

        --i2co => (

        --)
    );

display:
    entity SegmentDisplay
    port map (
        clk => CLK100MHZ,
        val => temperature,
        anodes => AN,
        cathodes => CA
    );

--MAIN:
--    process(CLK100MHZ, CPU_RESETN, cur_val)
--    begin
--        if rising_edge(CLK100MHZ) then
--        end if;
--    end process;

end Behavioral;
