# Load RUCKUS library
source $::env(RUCKUS_PROC_TCL)

# Load Source Code
loadRuckusTcl "$::DIR_PATH/pwm"
loadRuckusTcl "$::DIR_PATH/segment-display"
loadRuckusTcl "$::DIR_PATH/tri-color-led"
