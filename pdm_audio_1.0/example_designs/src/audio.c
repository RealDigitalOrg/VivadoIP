/*********************************************************************************
 * File: audio.c
 * Author: Tinghui Wang
 *
 * Copyright @ 2017 RealDigital.org
 *
 * Description:
 *   PDM Audio routines.
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

#include "audio.h"
#include "xil_printf.h"
#include "xscugic.h"
#include <math.h>

#define AUDIO_BaseAddr XPAR_PDM_AUDIO_S_AXI_BASEADDR
/* Note Physical Audio Buffer in audio_pdm core are always accessed 32-bit aligned
 * where the upper 16 bits of the 32-bit word are RAZ/WI.
 */
#define AUDIO_SpkLBufAddr ((uint32_t *) (AUDIO_BaseAddr + AUDIO_SPKL_BUF_OFFSET))
#define AUDIO_SpkRBufAddr ((uint32_t *) (AUDIO_BaseAddr + AUDIO_SPKR_BUF_OFFSET))
#define AUDIO_MicBufAddr  ((uint32_t *) (AUDIO_BaseAddr + AUDIO_MIC_BUF_OFFSET))

extern XScuGic gicInst;

uint16_t audioBuffer[AUDIO_BUF_MAX_LEN];
uint8_t micBufferCheck[460];
/* Length of valid data in the audio buffer */
uint32_t audioDataLength = 0;
/* Current start position to load audio data for Speaker (Left Channel) */
uint32_t spkLStart = 0;
/* Current start position to load audio data for Speaker (Right Channel) */
uint32_t spkRStart = 0;
/* Current position in audio buffer to save recorded voice from Microphone */
uint32_t micStart = 0;


/**
 * Generate sinusoidal wave of specific frequency
 * This function requires -lm in linker to add math library.
 *
 * @param frequency target frequency
 */
void Audio_GenerateSinWave(uint32_t frequency) {
	audioDataLength = AUDIO_PCM_FREQ / frequency;
	for (int i = 0; i < audioDataLength; i++) {
		audioBuffer[i] = (sin(2 * 3.1415926 * i / audioDataLength) + 1) * ((0x01U << 15) - 1);
	}
}

/**
 * Fill the buffer of a speaker channel from audio buffer
 *
 * @param loudness 0-9 where 9 is the loudest (full voltage swing on audio jack)
 * @param channel 0 - left, 1 - right
 * @param fillAll 0 - fill the current half-accessible buffer, 1 - fill all buffers
 */
void Audio_FillSpeaker(int loudness, int channel, int fillAll) {
	int i = 0;

	if(loudness < 0 || loudness > 9) return;
	if(channel != 0 && channel != 1) return;

	uint32_t *bufAddr =  (channel == 1) ? AUDIO_SpkRBufAddr : AUDIO_SpkLBufAddr;
	uint32_t spkStart = (channel == 1) ? spkRStart : spkLStart;
	uint32_t bufIDMask = (channel == 1) ? AUDIO_SPKR_BUFID_MASK : AUDIO_SPKL_BUFID_MASK;

	if(fillAll == 0) {
		// Only fill half of the buffer that is accessible to the processor
		uint32_t bufId = AudioReadReg(AUDIO_BaseAddr, AUDIO_INTR_OFFSET) & bufIDMask;

		for(i = 0; i < 512; i++) {
			if(bufId == 0) {
				*(bufAddr + i) = (uint32_t) (audioBuffer[(i + spkStart) % audioDataLength] / (10 - loudness));
			} else {
				*(bufAddr + i + 512) = (uint32_t) (audioBuffer[(i + spkStart) % audioDataLength] / (10 - loudness));
			}
		}
	} else {
		// Fill all buffer
		for(i = 0; i < 1024; i++) {
			*(bufAddr + i) = (uint32_t) (audioBuffer[i % audioDataLength] / (10 - loudness));
		}
	}

	// Update start location of the audio buffer for the corresponding channel
	if(channel == 1) {
		spkRStart = (spkRStart + i) % audioDataLength;
	} else {
		spkLStart = (spkLStart + i) % audioDataLength;
	}
}

void Audio_StartSpeakerL() {
	XScuGic_Enable(&gicInst, SPKL_INTR);

	// Enable interrupt for Speaker L
	AudioReg(AUDIO_BaseAddr, AUDIO_INTR_OFFSET) |= AUDIO_SPKL_INTR_MASK;

	// Enable Output to Speaker L
	AudioReg(AUDIO_BaseAddr, AUDIO_CTRL_OFFSET) |= AUDIO_SPKL_EN_MASK;
}

void Audio_StopSpeakerL() {
	XScuGic_Disable(&gicInst, SPKR_INTR);

	// Disable interrupt for Speaker L
	AudioReg(AUDIO_BaseAddr, AUDIO_INTR_OFFSET) &= ~AUDIO_SPKL_INTR_MASK;

	// Disable Output to Speaker L
	AudioReg(AUDIO_BaseAddr, AUDIO_CTRL_OFFSET) &= ~AUDIO_SPKL_EN_MASK;
}

void Audio_StartSpeakerR() {
	XScuGic_Enable(&gicInst, SPKR_INTR);

	// Enable interrupt for Speaker R
	AudioReg(AUDIO_BaseAddr, AUDIO_INTR_OFFSET) |= AUDIO_SPKR_INTR_MASK;

	// Enable Output to Speaker R
	AudioReg(AUDIO_BaseAddr, AUDIO_CTRL_OFFSET) |= AUDIO_SPKR_EN_MASK;

}

void Audio_StopSpeakerR() {
	XScuGic_Disable(&gicInst, SPKR_INTR);

	// Disable interrupt for Speaker R
	AudioReg(AUDIO_BaseAddr, AUDIO_INTR_OFFSET) &= ~AUDIO_SPKR_INTR_MASK;

	// Disable Output to Speaker R
	AudioReg(AUDIO_BaseAddr, AUDIO_CTRL_OFFSET) &= ~AUDIO_SPKR_EN_MASK;
}

void Audio_MicLoopbackStart() {
	// Disable Interrupt of Microphone
	AudioReg(AUDIO_BaseAddr, AUDIO_INTR_OFFSET) &= ~AUDIO_MIC_INTR_MASK;

	// Enable Microphone Loopback
	AudioReg(AUDIO_BaseAddr, AUDIO_MODE_OFFSET) = AUDIO_MIC_LOOPBACK_MASK;

	// Enable Input from Microphone
	AudioReg(AUDIO_BaseAddr, AUDIO_CTRL_OFFSET) |= AUDIO_MIC_EN_MASK;
}

void Audio_MicLoopbackStop() {
	// Disable Loopback
	AudioReg(AUDIO_BaseAddr, AUDIO_MODE_OFFSET) &= ~AUDIO_MIC_LOOPBACK_MASK;

	// Disable Input from Microphone
	AudioReg(AUDIO_BaseAddr, AUDIO_CTRL_OFFSET) &= ~AUDIO_MIC_EN_MASK;

}

void Audio_MicStartRecording() {
	// Set to the start of audio buffer
	micStart = 0;

	XScuGic_Enable(&gicInst, MIC_INTR);

	// Enable Interrupt of Microphone
	AudioReg(AUDIO_BaseAddr, AUDIO_INTR_OFFSET) |= AUDIO_MIC_INTR_MASK;

	// Enable Input from Microphone
	AudioReg(AUDIO_BaseAddr, AUDIO_CTRL_OFFSET) |= AUDIO_MIC_EN_MASK;
}

void Audio_MicStopRecording() {
	//xil_printf("%x, %x, %x\r\n", gicInst.IsReady, (uint32_t)&audioBuffer[micStart], micStart);

	// Disable Input from Microphone
	AudioReg(AUDIO_BaseAddr, AUDIO_CTRL_OFFSET) &= ~AUDIO_MIC_EN_MASK;
}

void Audio_MicIntrHandler(void *data) {
	//xil_printf("%x, %x, %x\r\n", gicInst.IsReady, (uint32_t)&audioBuffer[micStart], micStart);
	// Enable Interrupt of Microphone
	//AudioReg(AUDIO_BaseAddr, AUDIO_INTR_OFFSET) &= ~AUDIO_MIC_INTR_MASK;

	if(micStart >= AUDIO_BUF_MAX_LEN - 511) {
		Audio_MicStopRecording();
		audioDataLength = AUDIO_BUF_MAX_LEN;
		return;
	}
	// Save data to audio buffer until full
	uint32_t bufId = AudioReadReg(AUDIO_BaseAddr, AUDIO_INTR_OFFSET) & AUDIO_MIC_BUFID_MASK;
	if(bufId == 0) {
		micBufferCheck[micStart/512] = 0;
		for(uint32_t i = 0; i < 512; i++) {
			audioBuffer[micStart + i] = (uint16_t) *(AUDIO_MicBufAddr + i);
		}
	} else {
		micBufferCheck[micStart/512] = 1;
		for(uint32_t i = 0; i < 512; i++) {
			audioBuffer[micStart + i] = (uint16_t) *(AUDIO_MicBufAddr + 512 + i);
		}
	}
	micStart += 512UL;
	if(micStart >= AUDIO_BUF_MAX_LEN) {
		Audio_MicStopRecording();
		audioDataLength = AUDIO_BUF_MAX_LEN;
		return;
	}
	// Enable Interrupt of Microphone
	//AudioReg(AUDIO_BaseAddr, AUDIO_INTR_OFFSET) |= AUDIO_MIC_INTR_MASK;
}

void Audio_SpkLIntrHandler(void *data) {
	// Fetch the data from audio buffer
	Audio_FillSpeaker(9, 0, 0);
}

void Audio_SpkRIntrHandler(void *data) {
	// Fetch the data from audio buffer
	Audio_FillSpeaker(9, 1, 0);
}

void Audio_BufferAmp() {
	xil_printf("Audio: Find peak value and determine amplification\r\n");
	// Check all buffer to determine the peak value.
	uint16_t peakValue = 0;
	for(int i = 0; i < audioDataLength; i++) {
		if(audioBuffer[i] > peakValue) {
			peakValue = audioBuffer[i];
		}
	}

	int shift = 0;

	for(shift = 0; shift < 8; shift++) {
		if(((peakValue << shift) & 0x8000) != 0) {
			break;
		}
	}
	// Determine amplification factor
	xil_printf("Audio: Peak %0x, Shift %d bits\r\n", peakValue, shift);

	// Apply factor to all data
	for(int i = 0; i < audioDataLength; i++) {
		audioBuffer[i] = (uint16_t) (audioBuffer[i] << shift);
	}
}
