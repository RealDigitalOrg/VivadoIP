# HDMI/DVI Encoder

## Overview

The HDMI/DVI encoder translates VGA signal according to HDMI specification 1.3a with interfaces for audio and auxilary data.
It can also work in DVI mode with audio and auxilary data disabled for monitors that are not compliant with HDMI specification.

Part of the codes in this IP core originates from [XAPP460: Video Connectivity Using TMDS I/O in Spartan-3A FPGAs] written by Bob Feng.

**Note**:  
For monitor (even ones that with HDMI port) that are not fully compliant with HDMI specification, the video guardband defined in the HDMI specification can be interpreted as two extra pixel by the monitor.
As a result, you may see a two-pixel-wide light pink vertical line on the left of the monitor.
If you see this, configure the core in DVI mode (so that video guardband and preambles are both disabled) or see if there is an "AV" settings on your monitor to force it into HDMI compliant mode.

## Functional Description


## Core Configuration

**Red Channel Data Width**: integer, default 8-bit  
**Green Channel Data Width**: integer, default 8-bit  
**Blue Channel Data Width**: integer, default 8-bit  
**Mode**: HDMI or DVI

## Example Project

### Blackboard Rev. D

To generate example project targeting Blackboard Rev. D in Vivado 2018.2, browse to the `example_design` folder and run `make`.

If you want to create the example project at a different location, open Vivado, in the tcl command window, browse to the folder you want to create yourproject and run

```tcl
source ../VivadoIP/hdmi_tx_1.0/example_designs/tcl/project.tcl
```

Change the `../VivadoIP` to the location of VivadoIP directory on your system.

[XAPP460: Video Connectivity Using TMDS I/O in Spartan-3A FPGAs]:https://www.xilinx.com/support/documentation/application_notes/xapp460.pdf
