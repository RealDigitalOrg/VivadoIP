//////////////////////////////////////////////////////////////////////////////////
// Module: display_controller_v1_0
// Author: Tinghui Wang
//
// Copyright @ 2017 RealDigital.org
//
// Description:
//   Display Controller with configurable clock frequency and AXIS interface
//   for VDMA connection.
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
`timescale 1 ns / 1 ps

module display_controller_v1_0 #
(
	// Users to add parameters here

	// User parameters ends
	// Do not modify the parameters beyond this line


	// Parameters of Axi Slave Bus Interface S_AXI
	parameter integer C_S_AXI_DATA_WIDTH	= 32,
	parameter integer C_S_AXI_ADDR_WIDTH	= 7
)
(
	// Master Clock for pixel clock generation
	input wire mclk,
	// video output
	output wire pix_clk,
	output wire pix_clkx5,
	output wire hsync,
	output wire vsync,
	output wire vde,
	output [7:0] red,
	output [7:0] green,
	output [7:0] blue,
	// VDMA AXIS input
	output wire axis_fsync,
	input wire axis_aclk,
	input wire [31:0] axis_tdata,
	input wire [3:0] axis_tkeep,
	input wire axis_tlast,
	output wire axis_tready,
	input wire [0:0] axis_tuser,
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
// Instantiation of Axi Bus Interface S_AXI
display_controller_v1_0_S_AXI # ( 
	.C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
	.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
) display_controller_v1_0_S_AXI_inst (
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

	// Add user logic here

	// User logic ends

	endmodule
