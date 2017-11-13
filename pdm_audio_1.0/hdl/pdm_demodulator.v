`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module: pdm_demodulator
// Author: Tinghui Wang
//
// Copyright @ 2017 RealDigital.org
//
// History:
//   11/12/17: Created
//
// Description:
//   PDM signal is downsampled by a factor of 64 to generate 48KHz PCM audio signal.
//   A anti-aliasing CIC filter will be needed to get better audio performance.
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

module pdm_demodulator(
	input pcmClk,
    input pdm_mclk,
    input pdmRstn,
	output reg [15:0] pcmData,
    input pdm_mic 
);

reg [127:0] pdmDataShiftReg = 128'd0;
reg [7:0] pdmAccVar = 8'h0;

always @ (posedge pdm_mclk)
begin
	if (pdmRstn == 1'b0)
		pdmAccVar <= 8'h0;
	else
		pdmAccVar <= pdmAccVar + pdmDataShiftReg[0] - pdmDataShiftReg[127];
end

always @ (posedge pdm_mclk)
begin
	if(pdmRstn == 1'b0)
		pdmDataShiftReg <= 128'h0;
	else
		pdmDataShiftReg <= {pdmDataShiftReg[126:0], pdm_mic};
end

always @ (posedge pcmClk)
begin
	if(pdmRstn == 1'b0)
		pcmData <= 16'h0;
	else
		pcmData <= {pdmAccVar, 8'h0};
end

endmodule
