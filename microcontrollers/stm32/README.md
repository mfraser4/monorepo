# STM32 Microcontrollers

This directory contains projects deployed onto STMicroelectronics
microprocessors. This directory leverages the toolchains provided by
STM32CubeIDE and STM32CubeMX.

## STM32CubeMX

If CubeMX is installed in the home directory `$HOME/STM32CubeMX`, you can add the executable to your
path by adding the following line to your `~/.bashrc`:

```bash
# STM32CubeMX requires the installation folder directory context
alias stm32cubemx='pushd ~/STM32CubeMX/; ./STM32CubeMX; popd'

# Actual STM32CubeIDE version may differ
export PATH=/opt/st/stm32cubeide_1.15.1:$PATH
```
