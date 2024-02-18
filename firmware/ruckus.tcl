# Load RUCKUS environment and library
source $::env(RUCKUS_PROC_TCL)

# Load all source files to be run through GHDL
loadRuckusTcl "$::DIR_PATH/common"

## Load source files from each target
set targets [glob -type d "$::DIR_PATH/targets/*"]
foreach target $targets {
	puts "loadSource: $target/hdl"
	loadSource -dir "$target/hdl"
}
