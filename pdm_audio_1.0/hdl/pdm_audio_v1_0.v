`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////////
// Module: pdm_audio_v1_0
// Author: Tinghui Wang
//
// Copyright @ 2017 RealDigital.org
//
// Description:
//   Top level wrapper for pdm_audio IP Core.
//
// History:
//   11/12/17: Created
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


module pdm_audio_v1_0 #
(
	// Speaker Channels
	parameter integer SPEAKER_L_EN          = 1,
	parameter integer SPEAKER_R_EN          = 1,
	parameter integer MIC_EN                = 1,
	parameter integer pcmResetCyclesParam   = 2112,

	// Parameters of Axi Slave Bus Interface S_AXI
	parameter integer C_S_AXI_DATA_WIDTH	= 32,
	parameter integer C_S_AXI_ADDR_WIDTH	= 14
)
(
	// Users to add ports here
	input wire pdm_mclk,
	inout wire pdm_speaker_l,
	inout wire pdm_speaker_r,
	input wire pdm_mic,
	output wire pdm_mic_mclk,
	// Interrupts
	output wire spkLIntr,
	output wire spkRIntr,
	output wire micIntr,
	// User ports ends
	// Do not modify the ports beyond this line


	// Ports of Axi Slave Bus Interface S_AXI
	input wire  s_axi_aclk,
	input wire  s_axi_aresetn,
	input wire [C_S_AXI_ADDR_WIDTH-1 : 0] s_axi_awaddr,
	input wire [2 : 0] s_axi_awprot,
	input wire  s_axi_awvalid,
	output wire  s_axi_awready,
	input wire [C_S_AXI_DATA_WIDTH-1 : 0] s_axi_wdata,
	input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] s_axi_wstrb,
	input wire  s_axi_wvalid,
	output wire  s_axi_wready,
	output wire [1 : 0] s_axi_bresp,
	output wire  s_axi_bvalid,
	input wire  s_axi_bready,
	input wire [C_S_AXI_ADDR_WIDTH-1 : 0] s_axi_araddr,
	input wire [2 : 0] s_axi_arprot,
	input wire  s_axi_arvalid,
	output wire  s_axi_arready,
	output wire [C_S_AXI_DATA_WIDTH-1 : 0] s_axi_rdata,
	output wire [1 : 0] s_axi_rresp,
	output wire  s_axi_rvalid,
	input wire  s_axi_rready
);

// Clocks
wire pcmClk;
// Speaker PCM Data Port
wire pdmSpkLRst;
wire pdmSpkLEn;
wire [15:0] pcmSpkLData;
wire pdmSpkRRst;
wire pdmSpkREn;
wire [15:0] pcmSpkRData;
// Mic PCM Data
wire pdmMicEn;
wire pdmMicRst;
wire [15:0] pcmMicData;
wire pdmMicSpkLoopbackEn;
// AXI Registers
wire [31:0] pdmCtrlReg;
wire [31:0] pdmModeReg;

wire s_axi_pdmSpkLEn;
wire s_axi_pdmSpkREn;
wire s_axi_pdmMicEn;
wire s_axi_pdmMicSpkLoopback;

assign s_axi_pdmSpkLEn = pdmCtrlReg[0];
assign s_axi_pdmSpkREn = pdmCtrlReg[1];
assign s_axi_pdmMicEn = pdmCtrlReg[2];
assign s_axi_pdmMicSpkLoopback = pdmModeReg[0];

// Instantiation of Axi Bus Interface S_AXI
pdm_audio_v1_0_S_AXI # ( 
	.C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
	.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
) pdm_audio_v1_0_S_AXI_inst (
	.pcmClk(pcmClk),
	.pcmSpkLData(pcmSpkLData),
	.pcmSpkLDataEn(pdmSpkLEn),
	.pcmSpkLDataRst(pdmSpkLRst),
	.pcmSpkRData(pcmSpkRData),
	.pcmSpkRDataEn(pdmSpkREn),
	.pcmSpkRDataRst(pdmSpkRRst),
	.pcmMicData(pcmMicData),
	.pcmMicDataEn(pdmMicEn),
	.pcmMicDataRst(pdmMicRst),
	.pdmCtrlReg(pdmCtrlReg),
	.pdmModeReg(pdmModeReg),
    .spkLIntr(spkLIntr),
    .spkRIntr(spkRIntr),
    .micIntr(micIntr),
	.S_AXI_ACLK(s_axi_aclk),
	.S_AXI_ARESETN(s_axi_aresetn),
	.S_AXI_AWADDR(s_axi_awaddr),
	.S_AXI_AWPROT(s_axi_awprot),
	.S_AXI_AWVALID(s_axi_awvalid),
	.S_AXI_AWREADY(s_axi_awready),
	.S_AXI_WDATA(s_axi_wdata),
	.S_AXI_WSTRB(s_axi_wstrb),
	.S_AXI_WVALID(s_axi_wvalid),
	.S_AXI_WREADY(s_axi_wready),
	.S_AXI_BRESP(s_axi_bresp),
	.S_AXI_BVALID(s_axi_bvalid),
	.S_AXI_BREADY(s_axi_bready),
	.S_AXI_ARADDR(s_axi_araddr),
	.S_AXI_ARPROT(s_axi_arprot),
	.S_AXI_ARVALID(s_axi_arvalid),
	.S_AXI_ARREADY(s_axi_arready),
	.S_AXI_RDATA(s_axi_rdata),
	.S_AXI_RRESP(s_axi_rresp),
	.S_AXI_RVALID(s_axi_rvalid),
	.S_AXI_RREADY(s_axi_rready)
);

// PCM Clock Generation
reg [5:0] pcmClkCounter = 5'd0;

// PDM Master clock: 3.072Mhz
// PCM Sample Frequency is set to be 48KHz
always @ (posedge pdm_mclk)
begin
    pcmClkCounter <= pcmClkCounter + 1'b1;
end

assign pcmClk = pcmClkCounter[5];
	
wire pdmSpkL_o;
wire pdmSpkR_o;

generate
if (MIC_EN == 1 && (SPEAKER_L_EN == 1 || SPEAKER_R_EN == 1))
begin: SELF_MIC_SPK_LOOPBACK
	// Sychronization
	pdm_reset_sync # (
		.pcmResetCyclesParam(pcmResetCyclesParam)
	) pdm_reset_mic_loopback_inst (
		.s_axi_aclk(s_axi_aclk),
		.s_axi_aresetn(s_axi_aresetn),
		.s_axi_pdmEn(s_axi_pdmMicSpkLoopback),
		.pdm_mclk(pdm_mclk),
		.pdmRst(),
		.pdmEn(pdmMicSpkLoopbackEn)
	);
end
else
begin
	assign pdmMicSpkLoopbackEn = 1'b0;
end	
endgenerate


// Generate speaker left channel
generate
if (SPEAKER_L_EN == 1) begin: SPEAKER_L_PDM
	// Sychronization
	pdm_reset_sync # (
		.pcmResetCyclesParam(pcmResetCyclesParam)
	) pdm_reset_spkL_inst (
		.s_axi_aclk(s_axi_aclk),
		.s_axi_aresetn(s_axi_aresetn),
		.s_axi_pdmEn(s_axi_pdmSpkLEn),
		.pdm_mclk(pdm_mclk),
		.pdmRst(pdmSpkLRst),
		.pdmEn(pdmSpkLEn)
	);

	wire [15:0] pcmSpkLData_i;
	assign pcmSpkLData_i = (pdmMicSpkLoopbackEn) ? pcmMicData : pcmSpkLData;

	pdm_modulator pdm_modulator_spkL_inst (
		.pdm_mclk(pdm_mclk),
		.pdmRstn(pdmSpkLEn),
		.pcmData(pcmSpkLData_i),
		.pdm_speaker_o(pdmSpkL_o)
	);

	assign pdm_speaker_l = (pdmSpkLEn) ? pdmSpkL_o : 1'bZ;
end
else begin
	assign pdmSpkL_o = 1'b0;
	assign pdmSpkLRst = 1'b1;
	assign pdmSpkLEn = 1'b0;
	assign pdm_speaker_l = 1'bZ;
end
endgenerate	

generate
if (SPEAKER_R_EN == 1) begin: SPEAKER_R_PDM
	// Sychronization
	pdm_reset_sync # (
		.pcmResetCyclesParam(pcmResetCyclesParam)
	) pdm_reset_spkR_inst (
		.s_axi_aclk(s_axi_aclk),
		.s_axi_aresetn(s_axi_aresetn),
		.s_axi_pdmEn(s_axi_pdmSpkREn),
		.pdm_mclk(pdm_mclk),
		.pdmRst(pdmSpkRRst),
		.pdmEn(pdmSpkREn)
	);
	
	wire [15:0] pcmSpkRData_i;
	assign pcmSpkRData_i = (pdmMicSpkLoopbackEn) ? pcmMicData : pcmSpkRData;

	pdm_modulator pdm_modulator_spkR_inst (
		.pdm_mclk(pdm_mclk),
		.pdmRstn(pdmSpkREn),
		.pcmData(pcmSpkRData_i),
		.pdm_speaker_o(pdmSpkR_o)
	);

	assign pdm_speaker_r = (pdmSpkREn) ? pdmSpkR_o : 1'bZ;
end
else begin
	assign pdmSpkR_o = 1'b0;
	assign pdmSpkRRst = 1'b1;
	assign pdmSpkREn = 1'b0;
	assign pdm_speaker_r = 1'bZ;
end
endgenerate	

generate
if (MIC_EN == 1) begin: MIC_DPDM
	// Sychronization
	pdm_reset_sync # (
		.pcmResetCyclesParam(pcmResetCyclesParam)
	) pdm_reset_spkR_inst (
		.s_axi_aclk(s_axi_aclk),
		.s_axi_aresetn(s_axi_aresetn),
		.s_axi_pdmEn(s_axi_pdmMicEn),
		.pdm_mclk(pdm_mclk),
		.pdmRst(pdmMicRst),
		.pdmEn(pdmMicEn)
	);

	pdm_demodulator pdm_demodulator_mic_inst (
		.pcmClk(pcmClk),
		.pdm_mclk(pdm_mclk),
		.pdmRstn(pdmMicEn),
		.pcmData(pcmMicData),
		.pdm_mic(pdm_mic)
	);

	assign pdm_mic_mclk = pdm_mclk;
end
else begin
	assign pdmMicRst = 1'b1;
	assign pdmMicEn = 1'b0;
	assign pcmMicData = 16'h0;
	assign pdm_mic_mclk = 1'b0;
end
endgenerate	

endmodule
