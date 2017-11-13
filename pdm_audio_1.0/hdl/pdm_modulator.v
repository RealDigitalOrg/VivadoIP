`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module: pdm_modulator
// Author: Tinghui Wang
//
// Copyright @ 2017 RealDigital.org
//
// History:
//   11/12/17: Created
//
// Description:
//	 The PDM modulator uses Sigma-Delta modulation to quantize a 48KHz 16-bit
//   PCM audio signal into single-bit PDM signal sampled at 3.072MHz.
//
// License: BSD 3-Clause
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this 
//    list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice, 
//    this list of conditions and the following disclaimer in the documentation 
//    and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its contributors 
//    may be used to endorse or promote products derived from this software 
//    without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//////////////////////////////////////////////////////////////////////////////////

module pdm_modulator(
    input pdm_mclk,
    input pdmRstn,
	input [15:0] pcmData,
    output reg pdm_speaker_o
);

reg [15:0] pcmData_d1 = 16'h0;
reg [16:0] pdmVar = 17'h0;

always @ (posedge pdm_mclk)
begin
	if (pdmRstn == 1'b0)
		pcmData_d1 <= 16'h0;
	else
		pcmData_d1 <= pcmData;
end

// Sigma-Delta Modulation
// TODO: A digital low pass filter is needed when PCM signals are oversampled
// by 64 times.
always @ (posedge pdm_mclk)
begin
	if (pdmRstn == 1'b0)
		pdmVar <= 17'h0;
	else
		pdmVar <= {1'b0, pdmVar[15:0]} + pcmData_d1;
end

always @ (posedge pdm_mclk)
begin
	if (pdmRstn == 1'b0)
		pdm_speaker_o <= 1'b0;
	else
		pdm_speaker_o <= pdmVar[16];
end

endmodule
