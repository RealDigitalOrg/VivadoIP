//////////////////////////////////////////////////////////////////////////////////
// Module: axi_pwm_tb
// Author: Tinghui Wang
//
// Copyright @ 2019 RealDigital.org
//
// Description:
//   AXI PWM test bench
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

module axi_pwm_tb;

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
wire [5:0] pwm;


axi_pwm_v1_0 # (
    .NUM_CHANNELS(6)
) pwm_inst (
    .pwm(pwm),
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
    // Enable PWM
    #20 axi_write(32'h43c00000, 32'h1);
    #20 axi_write(32'h43c00010, 32'h1);
    #20 axi_write(32'h43c00020, 32'h1);
    #20 axi_write(32'h43c00030, 32'h1);
    #20 axi_write(32'h43c00040, 32'h1);
    #20 axi_write(32'h43c00050, 32'h1);
    #20 axi_write(32'h43c00060, 32'h1);
    #20 axi_write(32'h43c00070, 32'h1);
    // Configure Period
    #20 axi_write(32'h43c00004, 32'hF);
    #20 axi_write(32'h43c00014, 32'hF);
    #20 axi_write(32'h43c00024, 32'hF);
    #20 axi_write(32'h43c00034, 32'hF);
    #20 axi_write(32'h43c00044, 32'hF);
    #20 axi_write(32'h43c00054, 32'hF);
    #20 axi_write(32'h43c00064, 32'hF);
    #20 axi_write(32'h43c00074, 32'hF);
    // Configure Pulse Width
    #20 axi_write(32'h43c00008, 32'd0);
    #20 axi_write(32'h43c00018, 32'd2);
    #20 axi_write(32'h43c00028, 32'h4);
    #20 axi_write(32'h43c00038, 32'h6);
    #20 axi_write(32'h43c00048, 32'h8);
    #20 axi_write(32'h43c00058, 32'd10);
    #20 axi_write(32'h43c00068, 32'd12);
    #20 axi_write(32'h43c00078, 32'd14);
    #400;
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
