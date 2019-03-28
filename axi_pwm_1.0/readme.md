# AXI Pulse-Width Modulation IP Core

## Overview

PWM IP Core is designed to generate multi-channel pulse-width modulated signal based on AXI clock.
The IP core supports up to 8 PWM output channels.

## Register Definition

Register Table

| Offset | Register Name      | Size    | Default    |   
|:-------|:-------------------|---------|------------|
| 0x0000 | PWM0: CTRL         | 32-bits | 0x00000000 |
| 0x0004 | PWM0: PERIOD       | 32-bits | 0x00000000 |
| 0x0008 | PWM0: PULSE WIDTH  | 32-bits | 0x00000000 |
| 0x000C | Reserved           |         |            |
| 0x0010 | PWM1: CTRL         | 32-bits | 0x00000000 |
| 0x0014 | PWM1: PERIOD       | 32-bits | 0x00000000 |
| 0x0018 | PWM1: PULSE WIDTH  | 32-bits | 0x00000000 |
| 0x001C | Reserved           |         |            |
| 0x0020 | PWM2: CTRL         | 32-bits | 0x00000000 |
| 0x0024 | PWM2: PERIOD       | 32-bits | 0x00000000 |
| 0x0028 | PWM2: PULSE WIDTH  | 32-bits | 0x00000000 |
| 0x002C | Reserved           |         |            |
| 0x0030 | PWM3: CTRL         | 32-bits | 0x00000000 |
| 0x0034 | PWM3: PERIOD       | 32-bits | 0x00000000 |
| 0x0038 | PWM3: PULSE WIDTH  | 32-bits | 0x00000000 |
| 0x003C | Reserved           |         |            |
| 0x0040 | PWM4: CTRL         | 32-bits | 0x00000000 |
| 0x0044 | PWM4: PERIOD       | 32-bits | 0x00000000 |
| 0x0048 | PWM4: PULSE WIDTH  | 32-bits | 0x00000000 |
| 0x004C | Reserved           |         |            |
| 0x0050 | PWM5: CTRL         | 32-bits | 0x00000000 |
| 0x0054 | PWM5: PERIOD       | 32-bits | 0x00000000 |
| 0x0058 | PWM5: PULSE WIDTH  | 32-bits | 0x00000000 |
| 0x005C | Reserved           |         |            |
| 0x0060 | PWM6: CTRL         | 32-bits | 0x00000000 |
| 0x0064 | PWM6: PERIOD       | 32-bits | 0x00000000 |
| 0x0068 | PWM6: PULSE WIDTH  | 32-bits | 0x00000000 |
| 0x006C | Reserved           |         |            |
| 0x0070 | PWM7: CTRL         | 32-bits | 0x00000000 |
| 0x0074 | PWM7: PERIOD       | 32-bits | 0x00000000 |
| 0x0078 | PWM7: PULSE WIDTH  | 32-bits | 0x00000000 |
| 0x007C | Reserved           |         |            |

### Control Register (CTRL)

| Bit 31 - 1   | Bit 0   |
|--------------|---------|
| Reserved (0) | PWM_EN |

**MIC_EN:** Enable PWM Output.  
&ensp; 0: PWM Output disabled.  
&ensp; 1: PWM Output enabled.

### PWM Period Register (PERIOD)

| Bit 31 - 0    |
|---------------|
| PWM Period    |

This register specifies the length of the period of a pulse counted at AXI Clock frequency.
For example, if the AXI Master clock is 100MHz, to generate a 1KHz period, set this register to 100000 (0x000186A0).

### Pulse Width Register (PUlSE WIDTH)

| Bit 31 - 0    |
|---------------|
| PWM Pulse Width |

This register specifies the length of pulse width (active high) counted at AXI clock frequency.
For example, if the AXI Master clock is 100MHz, and the period of PWM is 1KHz. To generate a 50% duty cycle pulse, this register should be set to 500000.

## Example Project

### BlackBoard Rev. D

To generate example project for AXI PWM IP core targeting BlackBoard rev.D, you can source the `create_project.tcl` under `example_designs/BlackboardRevD/tcl/` in Vivado.

```bash
> vivado -mode batch -source tcl/create_project.tcl -tclargs --project_dir ./rgb_pwm_example --project_name example
```

To generate the example XSDK project, you can source the `xsdk_sw.tcl` to create the xsdk project.

```bash
> xsdk -batch -source tcl/xsdk_sw.tcl --project_dir ./rgb_pwm_example --project_name example
```

The command arguments `--project_dir` and `--project_name` are optional.

