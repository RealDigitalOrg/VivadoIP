# Seven Segment Display IP Core

## Overview

Seven segment display IP core is designed to power up to 16-digit seven segment display.

## Core Configuration

## Register Definition

Register Table

| Offset Address | Register Name      | Size    | Default    |   
|:---------------|:-------------------|---------|------------|
| 0x0000         | Control            | 32-bits | 0x00000000 |
| 0x0004-0x0013  | Digits             | 8-bits  | 0x00000000 |

### Control Register

| Bit 31 - 2   | Bit 1   | Bit 0   |
|--------------|---------|---------|
| Reserved (0) | MODE    |      EN |

**EN:** Enable Seven Segment Display Controller
&ensp; 0: Seven Segment Display Enabled
&ensp; 1: Seven Segment Display Disabled

**MODE:** Segment Mode Enable
&ensp; 0: Hexadecimal digit mode.
&ensp; 1: Segment Mode.

### Digit Registers

The seven segment display controller IP is designed to support up to 16 seven segment digits.

| Offset Address | Bit 31 - 24  | Bit 23 - 16 | Bit 15 - 8 | Bit 7 - 0  |
|:--------------:|--------------|-------------|------------|------------|
| 0x0004         | Digit Reg 3  | Digit Reg 2 | Digit Reg 1| Digit Reg 0|
| 0x0008         | Digit Reg 7  | Digit Reg 6 | Digit Reg 5| Digit Reg 4|
| 0x000C         | Digit Reg 11 | Digit Reg 10 | Digit Reg 9| Digit Reg 8|
| 0x0010         | Digit Reg 15 | Digit Reg 14| Digit Reg 13| Digit Reg 12|

Each digit is controlled by an 8-bit number.

| Mode |Bit 7 | Bit 6 | Bit 5 | Bit 4 | Bit 3 | Bit 2 | Bit 1 | Bit 0 |
|------|------|-------|-------|-------|-------|-------|-------|-------|
|Segment| DP | SG | SF | SE | SD | SC | SB | SA |
|Digit| DP | <td colspan=3> Reserved <td colspan=4> Digit in Hexidecimal

## Example Project

### BlackBoard Rev. D

To generate example project for seven segment display IP core targeting BlackBoard rev.D, you can source the `create_project.tcl` under `example_designs/BlackboardRevD/tcl/` in Vivado.

```bash
> vivado -mode batch -source tcl/create_project.tcl -tclargs --project_dir ./ssd_example --project_name example
```

To generate the example XSDK project, you can source the `xsdk_sw.tcl` to create the xsdk project.

```bash
> xsdk -batch -source tcl/xsdk_sw.tcl --project_dir ./ssd_example --project_name example
```

The command arguments `--project_dir` and `--project_name` are optional.

