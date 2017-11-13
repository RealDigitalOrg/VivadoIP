# PDM Audio IP Core

## Overview

PDM Audio IP Core is designed to provide 16-bit 48KHz mono audio input from a PDM microphone and single-ended PDM stereo/mono audio output to speaker/headphone jack.

## Functional Description



## Core Configuration



## Register Definition

Register Table

| Offset Address | Register Name      | Size    | Default    |   
|:---------------|:-------------------|---------|------------|
| 0x0000         | Control            | 32-bits | 0x00000000 |
| 0x0004         | Mode               | 32-bits | 0x00000000 |
| 0x0008-0x0FFF  | Reserved           |         |            |
| 0x1000-0x1FFF  | Speaker Buffer (L) |         |            |
| 0x2000-0x2FFF  | Speaker Buffer (R) |         |            |
| 0x3000-0x3FFF  | Mic Buffer         |         |            |

### Control Register

| Bit 31 - 3   | Bit 2  | Bit 1   | Bit 0   |
|--------------|--------|---------|---------|
| Reserved (0) | MIC_EN | SPKL_EN | SPKR_EN |

**MIC_EN:** Enable Microphone Input.  
&ensp; 0: Microphone disabled.  
&ensp; 1: Microphone enabled.

**SPKL_EN:** Enable speaker (left channel).  
&ensp; 0: Speaker (left channel) disabled.  
&ensp; 1: Speaker (left channel) enabled.
   
**SPKR_EN:** Enable speaker (right channel).  
&ensp; 0: Speaker (right channel) disabled.  
&ensp; 1: Speaker (right channel) enabled.
   
### Mode Register

| Bit 31 - 1   | Bit 0     |
|--------------|-----------|
| Reserved (0) | LOOP_BACK |

**LOOP_BACK:** Microphone loopback to both speaker channels (if they are enabled).  
&ensp; 0: No loopback.  
&ensp; 1: Direct loopback.

### Speaker Buffer (L/R), Microphone Buffer

Data in both speaker buffers and microphone buffer are 32-bit aligned, where only lower 16 bits of each 32-bit word are valid.

## Example Project

### Blackboard Rev. A

To generate example project targeting Blackboard Rev. A in Vivado 2017.3, browse to the folder where you want the project to be created and run

```bash
vivado -mode tcl -source ../VivadoIP/pdm_audio_1.0/example_designs/blackboardRevA/hw/create_project_2017_3.tcl -tclargs --origin_dir ../VivadoIP/pdm_audio_1.0/example_designs/blackboardRevA/hw/
```

or open Vivado, in tcl command window, browse to the folder you want to create your project and run

```tcl
source ../VivadoIP/pdm_audio_1.0/example_designs/blackboardRevA/hw/create_project_2017_3.tcl -tclargs --origin_dir ../VivadoIP/pdm_audio_1.0/example_designs/blackboardRevA/hw/
```

Change the "../VivadoIP" to the location of VivadoIP directory on your system.

After bitstream is generated, export the hardware to SDK. Create an empty application and add "main.c" file.

## To-do List

- PL330 DMA Support for input/output channels.
- Interrupt generation
