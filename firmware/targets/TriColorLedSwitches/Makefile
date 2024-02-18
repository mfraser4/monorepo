# Define target output
target: prom

# Define Firmware Version: v0.1.0.0
export PRJ_VERSION = 0x00010000

# Define target part
export PRJ_PART = xc7a100tcsg324-1

# Define the TOP_DIR path
export TOP_DIR = $(abspath $(PWD)/../..)

# Using XVC Debug bridge
export USE_XVC_DEBUG = 1

# Setup for releases.yaml
export RELEASE = tri-color-led-switches

# Use top level makefile
include ../../submodules/ruckus/system_vivado.mk
