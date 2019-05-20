/*********************************************************************************
 * File: audio.h
 * Author: Tinghui Wang
 *
 * Copyright @ 2017 RealDigital.org
 *
 * Description:
 *   PDM Audio routines header.
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

#ifndef SRC_AUDIO_H_
#define SRC_AUDIO_H_

#include "xparameters.h"
#include <xil_types.h>

#define AUDIO_PCM_FREQ 48000UL

#ifndef AUDIO_BUF_MAX_LEN
#define AUDIO_BUF_MAX_LEN (5 * AUDIO_PCM_FREQ)
#endif

#define MIC_INTR XPAR_FABRIC_PDM_AUDIO_MICINTR_INTR
#define SPKL_INTR XPAR_FABRIC_PDM_AUDIO_SPKLINTR_INTR
#define SPKR_INTR XPAR_FABRIC_PDM_AUDIO_SPKRINTR_INTR

#define AUDIO_CTRL_OFFSET   0x00UL
#define AUDIO_MODE_OFFSET   0x04UL
#define AUDIO_INTR_OFFSET   0x08UL

#define AUDIO_SPKL_BUF_OFFSET  0x1000UL
#define AUDIO_SPKR_BUF_OFFSET  0x2000UL
#define AUDIO_MIC_BUF_OFFSET   0x3000UL

#define AUDIO_SPKL_BUFID_MASK   0x10UL
#define AUDIO_SPKR_BUFID_MASK   0x20UL
#define AUDIO_MIC_BUFID_MASK	0x40UL

#define AUDIO_SPKL_INTR_MASK   0x01UL
#define AUDIO_SPKR_INTR_MASK   0x02UL
#define AUDIO_MIC_INTR_MASK	   0x04UL

#define AUDIO_SPKL_EN_MASK   0x01UL
#define AUDIO_SPKR_EN_MASK   0x02UL
#define AUDIO_MIC_EN_MASK	 0x04UL

#define AUDIO_MIC_LOOPBACK_MASK 0x01UL

#define AudioWriteReg(baseAddr, offset, value) (*((volatile uint32_t *) (baseAddr + offset)) = value)
#define AudioReadReg(baseAddr, offset)  AudioReg(baseAddr, offset)
#define AudioReg(baseAddr, offset)      (*((volatile uint32_t *) (baseAddr + offset)))

void Audio_GenerateSinWave(uint32_t frequency);
void Audio_FillSpeaker(int loudness, int channel, int fillAll);
void Audio_StartSpeakerL();
void Audio_StopSpeakerL();
void Audio_StartSpeakerR();
void Audio_StopSpeakerR();
void Audio_MicLoopbackStart();
void Audio_MicLoopbackStop();
void Audio_MicStartRecording();
void Audio_MicStopRecording();

void Audio_MicIntrHandler(void *data);
void Audio_SpkLIntrHandler(void *data);
void Audio_SpkRIntrHandler(void *data);

#endif /* SRC_AUDIO_H_ */
