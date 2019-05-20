//////////////////////////////////////////////////////////////////////////////////
// Module: wrapper
// Author: Tinghui Wang
//
// Copyright @ 2017 RealDigital.org
//
// Description:
//   Solid color screen for HDMI testing at 720p60 resolution.
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

module wrapper(
    // master clk
    input clk,
    input rst,
    input [7:0] sw,
    // hdmi output ports
    output  hdmi_tx_hpd,
    output TMDS_CLK_P,
    output TMDS_CLK_N,
    output  [2:0] TMDS_DATA_P,
    output  [2:0] TMDS_DATA_N
);
    
    wire pix_clk;
    wire pix_clkx5;
    
    wire locked;
    wire pix_rst;
        
    wire hsync;
    wire vsync;
    wire vde;
    wire [7:0] red;
    wire [7:0] green;
    wire [7:0] blue;
    wire [23:0] data;
    
    clk_wiz_0 clk_wiz_inst
    (
    // Clock out ports  
    .clk(pix_clk),
    .clk_x5(pix_clkx5),
    // Status and control signals               
    .reset(rst), 
    .locked(locked),
   // Clock in ports
    .clk_in(clk)
    );
    
    assign pix_rst = rst | ~locked;
    assign data[23:16] = red;
    assign data[15:8] = green;
    assign data[7:0] = blue;
        
    hdmi_tx_v1_0 # (
        .C_DATA_WIDTH(24),
        .C_RED_WIDTH(8),
        .C_GREEN_WIDTH(8),
        .C_BLUE_WIDTH(8),
        .MODE("DVI")
    ) hdmi_tx_inst (
        .pix_clk(pix_clk),
        .pix_clkx5(pix_clkx5),
        .pix_clk_locked(locked),
        .rst(rst),
        .pix_data(data),
        .hsync(hsync),
        .vsync(vsync),
        .vde(vde),
        .aux0_din(4'h0),
        .aux1_din(4'h0),
        .aux2_din(4'h0),
        .ade(1'h0),
        .TMDS_CLK_P(TMDS_CLK_P),
        .TMDS_CLK_N(TMDS_CLK_N),
        .TMDS_DATA_P(TMDS_DATA_P),
        .TMDS_DATA_N(TMDS_DATA_N)
    );

    localparam hs_end = 40;
    localparam hbp_end = 260;
    localparam hfp_begin = 1540;
    localparam hline_end = 1650;
    localparam vs_end = 5;
    localparam vbp_end = 25;
    localparam vfp_begin = 745;
    localparam vline_end = 750;

    reg [11:0] hcount = 12'h0;
    reg [11:0] vcount = 12'h0;

    always @(posedge pix_clk)
    begin
        if (pix_rst == 1'b1)
        begin
            hcount <= 12'h0;
            vcount <= 12'h0;
        end
        else
        begin
            if (hcount == hline_end - 1)
            begin
                hcount <= 12'h0;
                if (vcount == vline_end - 1)
                    vcount <= 12'h0;
                else
                    vcount <= vcount + 1'b1;
            end
            else
            begin
                hcount <= hcount + 1'b1;
                vcount <= vcount;
            end
        end
    end
    
    assign hsync = (hcount >= 0 && hcount < hs_end) ? 1'b1 : 1'b0;
    assign vsync = (vcount >= 0 && vcount < vs_end) ? 1'b1 : 1'b0;
    assign vde = (hcount >= hbp_end && hcount < hfp_begin && vcount >= vbp_end && vcount < vfp_begin) ? 1'b1: 1'b0;
    
    assign red = (vde == 1'b1) ? {sw[7:5], 5'h1F} : 8'h00;
    assign green = (vde == 1'b1) ? {sw[4:2], 5'h1F} : 8'h00;
    assign blue = (vde == 1'b1) ? {sw[1:0], 6'h3F} : 8'h00;
    
    assign hdmi_tx_hpd = 1'b1;
    
endmodule
