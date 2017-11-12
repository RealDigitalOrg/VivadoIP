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

## To-do List

- PL330 DMA Support for input/output channels.
- Interrupt generation
