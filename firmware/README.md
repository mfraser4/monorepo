# Firmware

- [Firmware](#firmware)
  - [Overview](#overview)
  - [Directory Structuring](#directory-structuring)
  - [Adding New Targets](#adding-new-targets)
    - [Makefile](#makefile)
    - [Top Module](#top-module)
    - [Ruckus TCL Script](#ruckus-tcl-script)
  - [Building a Target](#building-a-target)
  - [GHDL Syntax Checking](#ghdl-syntax-checking)
  - [Documentation](#documentation)
    - [PDF Documentation](#pdf-documentation)
  - [References](#references)

## Overview

This directory contains FPGA projects and is structured after Stanford's
[SLAC National Accelerator Laboratory's](https://en.wikipedia.org/wiki/SLAC_National_Accelerator_Laboratory)
repository structuring conventions.

See [Simple-10GbE-RUDP-KCU105-Example](https://github.com/slaclab/Simple-10GbE-RUDP-KCU105-Example).

## Directory Structuring

Device targets/projects are stored under `targets/`, and common, reusable
modules are stored under `common/`. The modules under `common/` all are included
as part of the `mf` library by convention.

SLAC's [`surf`](https://github.com/slaclab/surf) library is provided under
`submodules/`. This is a vast collection of pre-made modules and will naturally
be included if the standard repository conventions are followed.

## Adding New Targets

The `targets/PositiveIntegerCounterDisplay/` project is provided as a
"Hello World!" FPGA target that can be readily copy-pasted and modified for a
new target.

### Makefile

Within `targets/<target>/Makefile`, make sure the `PRJ_PART` is properly set to
the target device. If you are directly copy-pasting from
`targets/PositiveIntegerCounterDisplay`, the target will be built for the
[Nexys A7-100T (XC7A100T-1CSG324C)](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual),
and the `PRJ_PART` value need not be changed.

### Top Module

By convention, target-specific VHDL logic is housed within
`targets/<target>/hdl`. By convention, the top module should be named `<target>`
within `targets/<target>/hdl/<target>.vhd`. The target constraints file should
also be named `targets/<target>/hdl/<target>.xdc`. If you are copy-pasting from
`targets/PositiveIntegerCounterDisplay/`, the constraints file is also intended
for the Nexys A7-100T. Renaming the files and the module within the top VHDL
module to `<target>` will prepare the new target for properly building.

### Ruckus TCL Script

IMPORTANT: The steps within "Top Module" should be completed prior to this step.

Within `targets/<target>/ruckus.tcl`, make sure the `top` property is set with
the following convention:

```tcl
set_property top {<target>} [get_filesets sources_1]
```

Setting `top` to `<target>` will make sure that the top module set within
`targets/<target>/hdl/<target>.vhd` is used for the top module. If this is not
done properly, a build-time warning will be shown indicating that a module from
`submodules/surf` is the top module.

## Building a Target

Firstly, the `build/` directory must be created within this directory.

```bash
mkdir build
```

To build a target, `cd` into the target directory (`targets/<target>`, then run
the following:

```bash
make
```

To clean the target's build directory (`build/<target>`), run the following:

```bash
make clean
```

After building, the resulting project can be opened within Vivado:

```bash
make gui
```

NOTE: If your build target fails, it may still be possible to view your results
within Vivado (e.g. timing constraints failure). The build does not have to
succeed with an exit code `0` to be able to be opened within Vivado.

## GHDL Syntax Checking

The project uses GHDL to perform syntax checking like the `surf` library. To
lint this project's source code files for both `common/` and `targets/`,
run the following command from the `firmware/` directory:

```bash
make
```

## Documentation

Doxygen documentation for HTML and LaTeX will be built with the following
command:

```bash
make docs
```

### PDF Documentation

A PDF of the LaTeX documentation will be generated with the following command:

```bash
make pdf
```

## References

- [slaclab/surf](https://github.com/slaclab/surf): Surf project and links to
  documentation.
- [slaclab/ruckus](https://github.com/slaclab/ruckus): Ruckus build system upon
  which this directory structuring convention is based.
- [slaclab/Simple-10GbE-RUDP-KCU105-Example](https://github.com/slaclab/Simple-10GbE-RUDP-KCU105-Example/tree/main/firmware/targets/Simple10GbeRudpKcu105Example)
- [Nexys A7-100T Reference Manual](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual)
