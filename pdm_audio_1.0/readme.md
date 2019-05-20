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
| 0x0008         | Buffer interrupt   | 32-bits | 0x00000000 |
| 0x0008-0x0FFF  | Reserved           |         |            |
| 0x1000-0x1FFF  | Speaker Buffer (L) |         |            |
| 0x2000-0x2FFF  | Speaker Buffer (R) |         |            |
| 0x3000-0x3FFF  | Mic Buffer         |         |            |

### Control Register

| Bit 31 - 3   | Bit 2  | Bit 1   | Bit 0   |
|--------------|--------|---------|---------|
| Reserved (0) | MIC_EN | SPKR_EN | SPKL_EN |

**MIC_EN:** Enable Microphone Input.  
&ensp; 0: Microphone disabled.  
&ensp; 1: Microphone enabled.

**SPKR_EN:** Enable speaker (right channel).  
&ensp; 0: Speaker (right channel) disabled.  
&ensp; 1: Speaker (right channel) enabled.

**SPKL_EN:** Enable speaker (left channel).  
&ensp; 0: Speaker (left channel) disabled.  
&ensp; 1: Speaker (left channel) enabled.
   
### Mode Register

| Bit 31 - 1   | Bit 0     |
|--------------|-----------|
| Reserved (0) | LOOP_BACK |

**LOOP_BACK:** Microphone loopback to both speaker channels (if they are enabled).  
&ensp; 0: No loopback.  
&ensp; 1: Direct loopback.

### Interrupt Register
| Bit 31 - 7   | Bit 6 (RO) | Bit 5 (RO)  | Bit 4 (RO)  | Bit 3    | Bit 2       | Bit 1        | Bit 0        |
|--------------|------------|-------------|-------------|----------|-------------|--------------|--------------|
| Reserved (0) | MIC_BUF_ID | SPKL_BUF_ID | SPKR_BUF_ID | Reserved | MIC_INTR_EN | SPKL_INTR_EN | SPKR_INTR_EN |

**MIC_BUF_ID**: Microphone current buffer.  
&ensp; 0: Lower half of buffer (0x3000-0x37FF) is available to processor.  
&ensp; 1: Upper half of buffer (0x3800-0x3FFF) is available to processor.

**SPKR_BUF_ID**: Speaker (right channel) current buffer.  
&ensp; 0: Lower half of buffer (0x2000-0x27FF) is available to processor.  
&ensp; 1: Upper half of buffer (0x2800-0x2FFF) is available to processor.

**SPKL_BUF_ID**: Speaker (left channel) current buffer.  
&ensp; 0: Lower half of buffer (0x1000-0x17FF) is available to processor.  
&ensp; 1: Upper half of buffer (0x1800-0x1FFF) is available to processor.

**MIC_INTR_EN**: Microphone interrupt enable.  
&ensp; 0: Microphone interrupt disabled.  
&ensp; 1: Microphone interrupt enabled.

**SPKR_INTR_EN**: Speaker (right channel) interrupt enable.  
&ensp; 0: Speaker (right channel) interrupt disabled.  
&ensp; 1: Speaker (right channel) interrupt enabled.

**SPKL_INTR_EN**: Speaker (left channel) interrupt enable.  
&ensp; 0: Speaker (left channel) interrupt disabled.  
&ensp; 1: Speaker (left channel) interrupt enabled.



### Speaker Buffer (L/R), Microphone Buffer

Data in both speaker buffers and microphone buffer are 32-bit aligned, where only lower 16 bits of each 32-bit word are valid.

## Example Project

### BlackBoard Rev. D

To generate example project for PDM Audio IP core targeting BlackBoard rev.D, you can source the `create_project.tcl` under `example_designs/BlackboardRevD/tcl/` in Vivado.

```bash
> vivado -mode batch -source tcl/create_project.tcl -tclargs --project_dir ./pdm_audio_example --project_name example
```

To generate the example XSDK project, you can source the `xsdk_sw.tcl` to create the xsdk project.

```bash
> xsdk -batch -source tcl/xsdk_sw.tcl --project_dir ./pdm_audio_example --project_name example
```

## To-do List

- PL330 DMA Support for input/output channels.
