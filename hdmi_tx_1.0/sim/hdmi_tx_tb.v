//////////////////////////////////////////////////////////////////////////////////
// Module: hdmi_tx_tb
// Author: Tinghui Wang
//
// Copyright @ 2017 RealDigital.org
//
// Description:
//   Testbench for HDMI/DVI Encoder.
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
`timescale 1ns / 1ps

module hdmi_tx_tb();

reg clk = 1'b0;
reg rst = 1'b0;
reg [7:0] sw = 8'h00;
wire vga_hsync;
wire vga_vsync;
wire [3:0] vga_red;
wire [3:0] vga_green;
wire [3:0] vga_blue;
wire tmds_clk_p;
wire tmds_clk_n;
wire [2:0] tmds_data_p;
wire [2:0] tmds_data_n;

wrapper uut(
    .clk(clk),
    .rst(rst),
    .sw(sw),
    .vga_hsync(vga_hsync),
    .vga_vsync(vga_vsync),
    .vga_red(vga_red),
    .vga_green(vga_green),
    .vga_blue(vga_blue),
    .hdmi_tx_hpd(),
    .TMDS_CLK_P(tmds_clk_p),
    .TMDS_CLK_N(tmds_clk_n),
    .TMDS_DATA_P(tmds_data_p),
    .TMDS_DATA_N(tmds_data_n)
    );

always @ *
    #5 clk <= ~clk;

initial
begin
rst = 1'b1;
sw = 8'h00;
#20
rst = 1'b0;
end

endmodule
