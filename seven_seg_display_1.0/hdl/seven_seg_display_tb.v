//////////////////////////////////////////////////////////////////////////////////
// Module: seven_seg_display_tb 
// Author: Tinghui Wang
//
// Copyright @ 2019 RealDigital.org
//
// Description:
//   Seven Segment Display IP Test Bench 
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
`timescale 1ns / 1ps

module seven_seg_display_tb;

reg  s_axi_aclk = 1'b0;
reg  s_axi_aresetn;

// AW Channel
reg [31 : 0] s_axi_awaddr = 32'h0;
reg [2 : 0] s_axi_awprot = 3'd0;
reg  s_axi_awvalid = 1'b0;
wire  s_axi_awready;

// W Channel
reg [31 : 0] s_axi_wdata = 32'h0;
reg [3 : 0] s_axi_wstrb = 4'hF;
reg  s_axi_wvalid = 1'b0;
wire  s_axi_wready;

// W Response Channel
wire [1 : 0] s_axi_bresp;
wire  s_axi_bvalid;
reg  s_axi_bready = 1'b1;

// AR Channel
reg [31 : 0] s_axi_araddr = 32'h0;
reg [2 : 0] s_axi_arprot = 3'd0;
reg  s_axi_arvalid = 1'b0;
wire  s_axi_arready;

// R Channel
wire [31 : 0] s_axi_rdata;
wire [1 : 0] s_axi_rresp;
wire  s_axi_rvalid;
reg  s_axi_rready = 1'b1;

// Monitor
wire dp;
wire [6 : 0] cathode;
wire [14 : 0] anode;

seven_seg_display_v1_0 # (
    .C_NUM_DIGITS(15),
    .C_CLK_FREQ(1000000),
    .C_SCAN_FREQ(1000),
    .C_CATHODE_POLARITY("ACTIVE_LOW"),
    .C_ANODE_POLARITY("ACTIVE_LOW")
) ssd_inst (
    .dp(dp),
    .cathode(cathode),
    .anode(anode),
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awprot(s_axi_awprot),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awready(s_axi_awready),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wready(s_axi_wready),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(s_axi_bready),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arprot(s_axi_arprot),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arready(s_axi_arready),
    .s_axi_rdata(s_axi_rdata),
    .s_axi_rresp(s_axi_rresp),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready)
);

initial
begin
    // Assert Reset Signal
    s_axi_aresetn = 1'b0;
    // Wait for 2 clock cycle and then de-assert reset signal
    #200 s_axi_aresetn = 1'b1;
    // write 32'h0 to address 0x43c00000
    #20 axi_write(32'h43c00000, 32'h3);
    #20 axi_write(32'h43c00004, 32'h01020304);
    #20 axi_write(32'h43c00008, 32'h05060708);  
    #20 axi_write(32'h43c0000C, 32'h090A0B0C);
    #20 axi_write(32'h43c00010, 32'h8D8E8F80);
    #400;
    // Wait for 3 clock cycle and call axi_wri// write 32'h0 to address 0x43c00000
    #20 axi_write(32'h43c00000, 32'h1);
    #20 axi_write(32'h43c00004, 32'h01020304);
    #20 axi_write(32'h43c00008, 32'h05060708);  
    #20 axi_write(32'h43c0000C, 32'h090A0B0C);
    #20 axi_write(32'h43c00010, 32'h8D8E8F80);
end

// Clock Generation
always @ *
    #5 s_axi_aclk <= ~s_axi_aclk;

task axi_read;
    input [31:0] addr;
    begin
        @ (posedge s_axi_aclk);
        #1 s_axi_araddr = addr;
        s_axi_arvalid = 1'b1;
        while(s_axi_arvalid == 1'b1)
        begin
            @ (posedge s_axi_aclk);
            if(s_axi_arready == 1'b1)
                #1 s_axi_arvalid = 1'b0;
        end
        while(s_axi_rvalid == 1'b0) begin end
    end
endtask

// Verilog task: axi_write
task axi_write;
    // Two parameters that this task takes:
    // addr: 32-bit address (first parameter)
    // data: 32-bit data (second parameter)
    input [31:0] addr;
    input [31:0] data;
    begin // task begin
        // At next rising edge of s_axi_aclk,
        // 'data' is presented on s_axi_wdata bus,
        // s_axi_wvalid is dirven high to indicate that the value
        // presented on s_axi_wdata bus is valid.
        @ (posedge s_axi_aclk);
        #1 s_axi_wdata = data;
        s_axi_wvalid = 1'b1;
        // At next rising edge of s_axi_aclk,
        // 'addr' is presented on s_axi_awaddr bus,
        // s_axi_awvalid is driven high to indicate that the value
        // presented on s_axi_awaddr is valid.
        @ (posedge s_axi_aclk);
        #1 s_axi_awaddr = addr;
        s_axi_awvalid = 1'b1;
        // According to AXI4-Lite specification (handshake process),
        // wvalid and awvalid signal will be driven low after the value
        // on both bus are taken by peripheral (when both READY and VALID
        // are high). The end of the write transaction can be checked by
        // monitoring both AWVALID and WVALID signals. If both of them are
        // LOW again, wait for Write Response.
        while(s_axi_wvalid == 1'b1 || s_axi_awvalid == 1'b1)
        begin
            // During the write transaction, as host has prepared the data
            // on both Write Data Channel and Write Address Channel, it waits
            // on READY signal from the peripheral (it needs to be checked at
            // the rising edge of s_axi_aclk). If the peripheral is ready,
            // drive VALID low at next rising edge of s_axi_aclk.
            @ (posedge s_axi_aclk);
            if (s_axi_wready == 1'b1 && s_axi_awready == 1'b1)
            begin
                #1 s_axi_wvalid = 1'b0;
                s_axi_awvalid = 1'b0;
            end
            else if (s_axi_wready == 1'b1)
            begin
                #1 s_axi_wvalid = 1'b0;
            end
            else if (s_axi_awready == 1'b1)
            begin
                #1 s_axi_awvalid = 1'b0;
            end
        end
        // Wait for write response by checking BVALID signal.
        // If BVALID signal is low, keep waiting. If BVALID signal is high,
        // the write transaction ends.
        while(s_axi_bvalid == 1'b0) begin end
    end
endtask

endmodule
