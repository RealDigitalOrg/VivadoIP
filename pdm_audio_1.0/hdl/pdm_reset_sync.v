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

module pdm_reset_sync # (
	parameter integer pcmResetCyclesParam = 2112
)
(
	input s_axi_aclk,
	input s_axi_aresetn,
	input s_axi_pdmEn,
	input pdm_mclk,
	output pdmRst,
 	output pdmEn
);

wire pdmRstn;
reg pdmAxiRstn = 1'b0;
reg [11:0] pcmResetCounter = 12'h0;

assign pdmEn = pdmRstn;
assign pdmRst = ~pdmRstn;

// Reset Synchronization
xpm_cdc_async_rst #(
    //Common module parameters
    .DEST_SYNC_FF    (4), // integer; range: 2-10
    .INIT_SYNC_FF    (0), // integer; 0=disable simulation init values, 1=enable simulation init values
    .RST_ACTIVE_HIGH (0)  // integer; 0=active low reset, 1=active high reset
) pdm_enable_sync (
    .src_arst  (pdmAxiRstn),
    .dest_clk  (pdm_mclk),
    .dest_arst (pdmRstn)
);

// Drive pdmAxiRstn at least for a full PCM clock cycle (48KHz)
always @ (posedge s_axi_aclk)
begin
	if (s_axi_aresetn == 1'b0)
		pdmAxiRstn <= 1'b0;
	else
	begin
		if (pcmResetCounter == pcmResetCyclesParam)
			// Finished Reset
			pdmAxiRstn <= 1'b1;
		else
			// Keep in Reset
			pdmAxiRstn <= 1'b0;
	end
end

always @ (posedge s_axi_aclk)
begin
	if (s_axi_aresetn == 1'b0)
		pcmResetCounter <= 12'h0;
	else 
	begin
		if (s_axi_pdmEn == 1'b0)
			pcmResetCounter <= 12'h0;
		else
		begin
			if (pcmResetCounter == pcmResetCyclesParam)
				pcmResetCounter <= pcmResetCounter;
			else
				pcmResetCounter <= pcmResetCounter + 1'b1;
		end
	end
end

endmodule
