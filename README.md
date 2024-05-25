# Monorepo

- [Monorepo](#monorepo)
  - [Overview](#overview)
  - [Setup](#setup)
    - [Setup Overview](#setup-overview)
    - [Integrated Development Environments (IDEs)](#integrated-development-environments-ides)
      - [VSCode](#vscode)
      - [Sublime Text 4](#sublime-text-4)
      - [AMD Xilinx Vivado](#amd-xilinx-vivado)
      - [STMicroelectronics](#stmicroelectronics)
        - [STM32CubeCLT](#stm32cubeclt)
    - [Before Cloning](#before-cloning)
    - [Cloning](#cloning)
    - [After Cloning](#after-cloning)
      - [Debian/Ubuntu](#debianubuntu)
    - [Docker](#docker)

## Overview

This repository conveniently contains a collection of projects, prototypes, and
packages. The directories are organized by domain.

## Setup

**IMPORTANT: These setup instructions install a myriad of development tools. Be
sure to review the tools installed and determine whether you are comfortable
with the technology suite running on your machine(s).**

### Setup Overview

This monorepo seeks to provide a one-stop shop for development within many
programming languages. As such, there are a number of different setup steps that
need to be completed before being able to freely navigate and operate within
this repository. Setup and installation has been automated as much as possible,
but some tools still need to be installed manually. This section outlines how to
stand up your development environment.

Note: This repository's tooling and setup is most mature using Ubuntu 22.04. For
an experience most similar to the repository owner's workflow, it is recommended
to use the Ubuntu 22.04 desktop image from
[releases.ubuntu.com](https://www.releases.ubuntu.com/22.04/). All tools and
setup provided below can be installed in Ubuntu 22.04 as well.

### Integrated Development Environments (IDEs)

This repository provides out-of-the-box VSCode IDE settings and is the
recommended editor for this monorepo unless specified otherwise for a specific
portion of this repository.

#### VSCode

Follow VSCode's installation for your appropriate platform.

- [VSCode Setup](https://code.visualstudio.com/docs/setup/setup-overview)

This repository comes with a list of recommended extensions for a curated
developer experience.

#### Sublime Text 4

Sublime Text 4 provides some solid VHDL tooling (see `firmware` projects). The
following configuration is used writing VHDL:

- [Sublime Text 4 on Ubuntu](https://www.sublimetext.com/docs/linux_repositories.html)

Installed packages:

- Package Control
- DoxyDoxygen
- GitGutter
- Smart VHDL
- XDC

#### AMD Xilinx Vivado

Vivado is used in this repository primarily to provide a development toolchain.
The Vivado IDE is useful for visualization of build artifacts, but it is not
mandatory to use the IDE to write VHDL, as FPGA development has been setup to be
able to build and run almost entirely from the command line.

Download the Linux Self Extracting Web Installer from Xilinx's downloads page:

- [Downloads](https://www.xilinx.com/support/download.html)

Run the downloaded `.bin` file to initiate the installer.

After completing the installation, add the following line to your `~/.bashrc`
to source Vivado-specific settings:

```sh
# Source Vivado settings (version may be different depending on which version
# you download)
source /opt/Xilinx/Vivado/2023.2/settings64.sh
```

Vivado (instructions below) does not have a dark theme out of the box and is
comparably less performant next to Sublime Text.

#### STMicroelectronics

The STMicroelectronics IDEs and toolchains can be downloaded here:

- [STM32CubeMX](https://www.st.com/en/development-tools/stm32cubemx.html)
- [STM32CubeIDE](https://www.st.com/en/development-tools/stm32cubeide.html)

On Ubuntu, add the following lines to your `~/.bashrc` for convenience:

```bash
# STM32CubeMX requires the installation folder context
alias stm32cubemx='pushd ~/STM32CubeMX/; ./STM32CubeMX; popd'

# Actual STM32CubeIDE version may differ
export PATH=/opt/st/stm32cubeide_1.15.1:$PATH
```

##### STM32CubeCLT

The STM32 CLI tools are required for projects contained within
`microcontrollers/stm32`. Follow the instructions at the link below:

- [STM32CubeCLT installation guide](https://www.st.com/resource/en/user_manual/dm00915661-.pdf)

Add the following lines to your `~/.bashrc` to see the STM32 CLI binaries:

```bash
# NOTE: This MUST come after Vivado's `source .../settings64.sh` command, as
# this pulls in a newer version of CMake
export PATH=/opt/st/stm32cubeclt_1.15.1/STM32CubeProgrammer/bin:/opt/st/stm32cubeclt_1.15.1/GNU-tools-for-STM32/bin:/opt/st/stm32cubeclt_1.15.1/CMake/bin:/opt/st/stm32cubeclt_1.15.1/STLink-gdb-server/bin:$PATH
```

For reference, here is a quick-start guide to the STM32CubeCLT toolset:

- [STM32Cube command-line toolset quick start guide](https://www.st.com/resource/en/user_manual/um3088-stm32cube-commandline-toolset-quick-start-guide-stmicroelectronics.pdf)

### Before Cloning

There are Git submodules within this repository that leverage Git LFS. Be sure
to run the following setup script _before_ cloning the repository:

```bash
git lfs install
```

### Cloning

Recursively clone to include the Git submodules:

```bash
git clone --recursive https://github.com/mfraser4/monorepo.git
```

### After Cloning

#### Debian/Ubuntu

Run the following in your terminal **_WITHOUT_** `sudo`  permissions. Using
`sudo` with this script will unnecessarily provide tools `root` permissions. The
script uses `sudo` wherever necessary.

```sh
bash scripts/setup.deb.bash
```

**NOTE: Docker is installed as a part of the setup script and the user is added
to the `docker` group. You will need to log out and back in again for these
changes to take effect.**

### Docker

This repository uses Docker as well for rapid prototyping. For Ubuntu, Docker is
already auto-installed in `setup.deb.bash`. The user `$USER` that runs the setup
script will also be auto-added to the `docker` group.

- [Docker Docs](https://docs.docker.com/)
