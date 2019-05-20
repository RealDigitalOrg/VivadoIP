/*********************************************************************************
 * File: main.c
 * Author: Tinghui Wang
 *
 * Copyright @ 2017 RealDigital.org
 *
 * Description:
 *   Audio test for speaker and microphone.
 *   - Sinusoidal wave for speaker (L/R)
 *   - Microphone Loopback
 *   - Recording (10s)
 *   - Playback (10s)
 *
 * History:
 *   11/13/17: Created
 *
 * License: BSD 3-Clause
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *********************************************************************************/

#include "xparameters.h"
#include <xil_types.h>
#include <math.h>
#include <stdio.h>
#include "xil_printf.h"
#include "xil_exception.h"
#include "audio.h"
#include "xscugic.h"
#include "xscugic_hw.h"

typedef struct {
	Xil_ExceptionHandler Handler;
	void *Data;
} XExc_VectorTableEntry;

extern XExc_VectorTableEntry XExc_VectorTable[];

XScuGic gicInst;


/**
 * Initialize Interrupts
 */
int GicInit() {
	int status;
	XScuGic_Config *config = XScuGic_LookupConfig(XPAR_PS7_SCUGIC_0_DEVICE_ID);
	status = XScuGic_CfgInitialize(&gicInst, config, config->CpuBaseAddress);
	if(status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler) XScuGic_InterruptHandler, &gicInst);
	Xil_ExceptionEnable();

	XScuGic_Connect(&gicInst, SPKL_INTR, Audio_SpkLIntrHandler, NULL);
	XScuGic_Connect(&gicInst, SPKR_INTR, Audio_SpkRIntrHandler, NULL);
	XScuGic_Connect(&gicInst, MIC_INTR, Audio_MicIntrHandler, NULL);

	XScuGic_SetPriorityTriggerType(&gicInst, MIC_INTR, 0xa0, 0x03);
	XScuGic_SetPriorityTriggerType(&gicInst, SPKL_INTR, 0xa0, 0x03);
	XScuGic_SetPriorityTriggerType(&gicInst, SPKR_INTR, 0xa0, 0x03);

	return XST_SUCCESS;
}

int main() {
	char cmd;
	xil_printf("Speaker Test\r\n\n");
	xil_printf("Init waveform array...\r\n");

	GicInit();
	Audio_GenerateSinWave(440);

	while(1) {
		xil_printf("a - speakerL test start\r\n");
		xil_printf("b - speakerL test stop\r\n");
		xil_printf("c - speakerR test start\r\n");
		xil_printf("d - speakerR test stop\r\n");
		xil_printf("e - mic loopback start\r\n");
		xil_printf("f - mic loopback stop\r\n");
		xil_printf("g - mic recording start\r\n");
		xil_printf("h - mic recording stop\r\n");
//		xil_printf("0 to 9 - set loudness\r\n");
//		while(1);
		cmd = getchar();
		switch(cmd) {
		case 'a':
			xil_printf("Start SpeakerL\r\n");
			Audio_StartSpeakerL();
			break;
		case 'b':
			xil_printf("Stop SpeakerL\r\n");
			Audio_StopSpeakerL();
			break;
		case 'c':
			xil_printf("Start SpeakerR\r\n");
			Audio_StartSpeakerR();
			break;
		case 'd':
			xil_printf("Stop SpeakerR\r\n");
			Audio_StopSpeakerR();
			break;
		case 'e':
			xil_printf("Mic Loopback Test\r\n");
			Audio_MicLoopbackStart();
			Audio_StartSpeakerL();
			Audio_StartSpeakerR();
			break;
		case 'f':
			xil_printf("Mic Loopback Stop\r\n");
			Audio_MicLoopbackStop();
			Audio_StopSpeakerL();
			Audio_StopSpeakerR();
			break;
		case 'g':
			xil_printf("Start Recording\r\n");
			Audio_MicStartRecording();
			break;
		case 'h':
			xil_printf("Play Recording\r\n");
			// Check Recording Level - Amplify if needed
			Audio_BufferAmp();
			Audio_StartSpeakerL();
			Audio_StartSpeakerR();
			break;
		default:
//			if(cmd <= '9' && cmd >= '0') {
//				Audio_StopSpeakerL();
//				Audio_StopSpeakerR();
//				Audio_MicLoopbackStop();
//			}
			break;
		}
	}
}
