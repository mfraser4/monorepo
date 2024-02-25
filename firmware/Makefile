ifndef MODULES
export MODULES = $(abspath $(PWD)/submodules/)
endif

# GHDL/ruckus source loading
export RUCKUS_DIR   = $(MODULES)/ruckus
export TOP_DIR      = $(abspath $(PWD))
export PROJ_DIR     = $(abspath $(PWD))
export TARGETS_DIR  = $(TOP_DIR)/targets
export OUT_DIR      = $(PROJ_DIR)/build
export OUT_DIR_DOCS = $(OUT_DIR)/doxygen

# Path to GHDL proc.tcl
export RUCKUS_PROC_TCL = $(RUCKUS_DIR)/ghdl/proc.tcl

# Bypassing Xilinx Specific code
export VIVADO_VERSION = -1.0

# Override the submodule check because ruckus external of this repo
export OVERRIDE_SUBMODULE_LOCKS = 1

# GHDL build flags
GHDLFLAGS = --workdir=$(OUT_DIR) --ieee=synopsys -fexplicit -frelaxed-rules --warn-no-library

# Include the shared ruckus Makefile header
include $(RUCKUS_DIR)/system_shared.mk

# Override system_shared.mk build string
export BUILD_SVR_TYPE = $(shell python3 -m platform)
export GHDL_VERSION   = $(shell ghdl -v 2>&1 | head -n 1)
export BUILD_STRING   = $(PROJECT): $(GHDL_VERSION), $(BUILD_SYS_NAME) ($(BUILD_SVR_TYPE)), Built $(BUILD_DATE) by $(BUILD_USER)

all: syntax

# Test of the variables
.PHONY : test
test:
	@echo PWD: $(PWD)
	@echo MODULES: $(MODULES)
	@echo RUCKUS_DIR: $(RUCKUS_DIR)
	@echo PROJ_DIR: $(PROJ_DIR)
	@echo OUT_DIR: $(OUT_DIR)
	@echo RUCKUS_PROC_TCL: $(RUCKUS_PROC_TCL)
	@echo VIVADO_VERSION: $(VIVADO_VERSION)

# Find all the source code and load it into GHDL
.PHONY : src
src:
	@$(RUCKUS_DIR)/ghdl/import.tcl

# Find all the source code and load it into GHDL
.PHONY : syntax
syntax: src
	@echo "============================================================================="
	@echo VHDL Syntax Checking:
	@echo "============================================================================="
	@ghdl -i $(GHDLFLAGS) --work=mf $(OUT_DIR)/SRC_VHDL/mf/*
	@ghdl -i $(GHDLFLAGS) --work=work $(OUT_DIR)/SRC_VHDL/work/*
	@echo "============================================================================="
	@echo VHDL Syntax Checking Done.
	@echo "============================================================================="

.PHONY : docs
docs:
	@rm -rf $(OUT_DIR_DOCS)
	@doxygen Doxyfile

.PHONY : pdf
pdf: docs
	@make -C $(OUT_DIR_DOCS)/latex pdf

.PHONY : show-docs
show-docs: docs pdf
	@firefox $(OUT_DIR_DOCS)/latex/refman.pdf &
	@firefox $(OUT_DIR_DOCS)/html/index.html &

.PHONY : clean
clean:
	@rm -rf build/*
