# LSM9DS1 SPI Bridge IP

## Overview

This IP bridges a SPI master controller with multiple slave select to the SPI interface of STMicroelectronics LSM9DS1 iNEMO intertial module with 3D magnetometer, 3D accelerometer and 3D gyroscope.

## Core configuration

`SS0` is connected to `SPI_SS_AG` and `SS1` is connected to `SPI_SS_M`.

## Example Project

### BlackBoard Rev. D

To generate example project for LSM9DS1 SPI Bridge targeting BlackBoard rev.D, you can source the `create_project.tcl` under `example_designs/BlackboardRevD/tcl/` in Vivado.

```bash
> vivado -mode batch -source tcl/create_project.tcl -tclargs --project_dir ./lsm9ds1_example --project_name example
```

To generate the example XSDK project, you can source the `xsdk_sw.tcl` to create the xsdk project.

```bash
> xsdk -batch -source tcl/xsdk_sw.tcl --project_dir ./lsm9ds1_example --project_name example
```

The command arguments `--project_dir` and `--project_name` are optional.
  
