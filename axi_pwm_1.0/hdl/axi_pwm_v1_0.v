//////////////////////////////////////////////////////////////////////////////////
// Module: axi_pwm_v1_0
// Author: Tinghui Wang
//
// Copyright @ 2019 RealDigital.org
//
// Description:
//   AXI PWM IP core wrapper
//
// History:
//   02/23/19: Created
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

	module axi_pwm_v1_0 #
	(
		// Users to add parameters here
        parameter integer NUM_CHANNELS = 6,
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S_AXI
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		parameter integer C_S_AXI_ADDR_WIDTH	= 7
	)
	(
		// Users to add ports here
        output wire [NUM_CHANNELS-1 : 0] pwm, 
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
	
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg0;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg2;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg3;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg4;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg5;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg6;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg7;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg8;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg9;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg10;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg11;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg12;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg13;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg14;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg15;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg16;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg17;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg18;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg19;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg20;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg21;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg22;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg23;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg24;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg25;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg26;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg27;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg28;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg29;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg30;
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg31;
	wire [C_S_AXI_DATA_WIDTH*32-1:0] slv_regs;

	assign slv_regs = {
        slv_reg31,       
        slv_reg30, 
        slv_reg29, 
        slv_reg28, 
        slv_reg27, 
        slv_reg26, 
        slv_reg25, 
        slv_reg24, 
        slv_reg23, 
        slv_reg22, 
        slv_reg21,
        slv_reg20,
        slv_reg19,
        slv_reg18,
        slv_reg17,
        slv_reg16,
        slv_reg15,
        slv_reg14,
        slv_reg13,
        slv_reg12,
        slv_reg11,
        slv_reg10,
        slv_reg9,
        slv_reg8,
        slv_reg7,
        slv_reg6,
        slv_reg5,
        slv_reg4,
        slv_reg3,
        slv_reg2,
        slv_reg1,
        slv_reg0
	};
	
// Instantiation of Axi Bus Interface S_AXI
	axi_pwm_v1_0_S_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
	) axi_pwm_v1_0_S_AXI_inst (
	    // Slave registers
	    .slv_reg0(slv_reg0),
	    .slv_reg1(slv_reg1),
	    .slv_reg2(slv_reg2),
	    .slv_reg3(slv_reg3),
	    .slv_reg4(slv_reg4),
	    .slv_reg5(slv_reg5),
	    .slv_reg6(slv_reg6),
	    .slv_reg7(slv_reg7),
	    .slv_reg8(slv_reg8),
	    .slv_reg9(slv_reg9),
	    .slv_reg10(slv_reg10),
	    .slv_reg11(slv_reg11),
	    .slv_reg12(slv_reg12),
	    .slv_reg13(slv_reg13),
	    .slv_reg14(slv_reg14),
	    .slv_reg15(slv_reg15),
	    .slv_reg16(slv_reg16),
	    .slv_reg17(slv_reg17),
	    .slv_reg18(slv_reg18),
	    .slv_reg19(slv_reg19),
	    .slv_reg20(slv_reg20),
	    .slv_reg21(slv_reg21),
	    .slv_reg22(slv_reg22),
	    .slv_reg23(slv_reg23),
	    .slv_reg24(slv_reg24),
	    .slv_reg25(slv_reg25),
	    .slv_reg26(slv_reg26),
	    .slv_reg27(slv_reg27),
	    .slv_reg28(slv_reg28),
	    .slv_reg29(slv_reg29),
	    .slv_reg30(slv_reg30),
	    .slv_reg31(slv_reg31),
	    // AXI interface
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
	genvar i;
    generate
    for (i = 0; i < NUM_CHANNELS; i = i+1)
    begin
        pwm_core pwm_inst(
            .clk(s_axi_aclk),
            .rst_n(s_axi_aresetn),
            .en(slv_regs[i * 4 * C_S_AXI_DATA_WIDTH]),
            .period(slv_regs[(i*4+2)*C_S_AXI_DATA_WIDTH-1 : (i*4+1)*C_S_AXI_DATA_WIDTH]),
            .pulse_width(slv_regs[(i*4+3)*C_S_AXI_DATA_WIDTH-1 : (i*4+2)*C_S_AXI_DATA_WIDTH]),
            .pwm(pwm[i])
        );
    end
    endgenerate
	// User logic ends

	endmodule
