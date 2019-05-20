//////////////////////////////////////////////////////////////////////////////////
// Module: encode
// Author: Tinghui Wang
//
// Copyright @ 2017-2019 RealDigital.org
//
// Description:
//   8b/10b TMDS encoder.
//   In HDMI Mode (according to HDMI 1.3a):
//     - Video: TMDS
//     - Audio: TERC4
//     - Control: Fixed
//   In DVI Mode:
//     - Video: TMDS, No guardband
//     - Audio: Disabled
//     - Control: Only HSYNC and VSYNC on Blue channel is encoded.
//                No preambles.
//
// Note:
//   Part of the codes used in this module originated from XAPP460 by Bob Feng.
//
// History:
//   11/12/17: Created
//   02/01/19: Set default MODE to DVI.
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
// Xilinx Disclaimer From XAPP460:
//   LIMITED WARRANTY AND DISCLAMER. These designs are provided to you "as is". 
//   Xilinx and its licensors makeand you receive no warranties or conditions, 
//   express, implied, statutory or otherwise, and Xilinx specifically disclaims 
//   any implied warranties of merchantability, non-infringement,or fitness for a 
//   particular purpose. Xilinx does notwarrant that the functions contained in 
//   these designs will meet your requirements, or that the operation of these 
//   designs will be uninterrupted or error free, or that defects in the Designs
//   will be corrected. Furthermore, Xilinx does not warrantor make any 
//   representations regarding use or the results ofthe use of the designs in 
//   terms of correctness, accuracy, reliability, or otherwise.
//
//   LIMITATION OF LIABILITY. In no event will Xilinx or its licensors be liable 
//   for any loss of data, lost profits,cost or procurement of substitute goods or 
//   services, or for any special, incidental, consequential, or indirect damages
//   arising from the use or operation of the designs or accompanying 
//   documentation, however caused and on anytheory of liability. This limitation 
//   will apply even if Xilinx has been advised of the possibility of such damage. 
//   This limitation shall apply not-withstanding the failure of the essential 
//   purpose of any limited remedies herein.
//
//   Copyright  2006 Xilinx, Inc.
//   All rights reserved
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1 ps / 1ps

module encode # (
  parameter CHANNEL="BLUE",
  parameter MODE="DVI"
)(
  input  wire       clkin,    // pixel clock input
  input  wire       rstin,    // async. reset input (active high)
  input  wire [7:0] vdin,     // video data inputs: expect registered
  input  wire [3:0] adin,     // audio/aux data inputs: expect registered
  input  wire       c0,       //
  input  wire       c1,       //
  input  wire       vde,      // video de input
  input  wire       ade,      // audio/aux de input
  output reg [9:0]  dout      // data outputs
);


  localparam VIDEOGBND = (CHANNEL == "BLUE") ?  10'b1011001100 : 
                         (CHANNEL == "GREEN") ? 10'b0100110011 : 10'b1011001100;

  localparam DILNDGBND = (CHANNEL == "GREEN") ? 10'b0100110011 :
                         (CHANNEL == "RED") ?   10'b0100110011 : 10'bxxxxxxxxxx; 

  ////////////////////////////////////////////////////////////
  // Counting number of 1s and 0s for each incoming pixel
  // component. Pipe line the result.
  // Register Data Input so it matches the pipe lined adder
  // output
  ////////////////////////////////////////////////////////////
  reg [3:0] n1d; //number of 1s in video din
  reg [7:0] vdin_q;

  always @ (posedge clkin) begin
    n1d <=#1 vdin[0] + vdin[1] + vdin[2] + vdin[3] + vdin[4] + vdin[5] + vdin[6] + vdin[7];

    vdin_q <=#1 vdin;
  end

  ///////////////////////////////////////////////////////
  // Stage 1: 8 bit -> 9 bit
  // Refer to DVI 1.0 Specification, page 29, Figure 3-5
  ///////////////////////////////////////////////////////
  wire decision1;

  assign decision1 = (n1d > 4'h4) | ((n1d == 4'h4) & (vdin_q[0] == 1'b0));

  wire [8:0] q_m;
  assign q_m[0] = vdin_q[0];
  assign q_m[1] = (decision1) ? (q_m[0] ^~ vdin_q[1]) : (q_m[0] ^ vdin_q[1]);
  assign q_m[2] = (decision1) ? (q_m[1] ^~ vdin_q[2]) : (q_m[1] ^ vdin_q[2]);
  assign q_m[3] = (decision1) ? (q_m[2] ^~ vdin_q[3]) : (q_m[2] ^ vdin_q[3]);
  assign q_m[4] = (decision1) ? (q_m[3] ^~ vdin_q[4]) : (q_m[3] ^ vdin_q[4]);
  assign q_m[5] = (decision1) ? (q_m[4] ^~ vdin_q[5]) : (q_m[4] ^ vdin_q[5]);
  assign q_m[6] = (decision1) ? (q_m[5] ^~ vdin_q[6]) : (q_m[5] ^ vdin_q[6]);
  assign q_m[7] = (decision1) ? (q_m[6] ^~ vdin_q[7]) : (q_m[6] ^ vdin_q[7]);
  assign q_m[8] = (decision1) ? 1'b0 : 1'b1;

  /////////////////////////////////////////////////////////
  // Stage 2: 9 bit -> 10 bit
  // Refer to DVI 1.0 Specification, page 29, Figure 3-5
  /////////////////////////////////////////////////////////
  reg [3:0] n1q_m, n0q_m; // number of 1s and 0s for q_m
  always @ (posedge clkin) begin
    n1q_m  <=#1 q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7];
    n0q_m  <=#1 4'h8 - (q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7]);
  end

  parameter CTRLTOKEN0 = 10'b1101010100;
  parameter CTRLTOKEN1 = 10'b0010101011;
  parameter CTRLTOKEN2 = 10'b0101010100;
  parameter CTRLTOKEN3 = 10'b1010101011;

  reg [4:0] cnt; //disparity counter, MSB is the sign bit
  wire decision2, decision3;

  assign decision2 = (cnt == 5'h0) | (n1q_m == n0q_m);
  /////////////////////////////////////////////////////////////////////////
  // [(cnt > 0) and (N1q_m > N0q_m)] or [(cnt < 0) and (N0q_m > N1q_m)]
  /////////////////////////////////////////////////////////////////////////
  assign decision3 = (~cnt[4] & (n1q_m > n0q_m)) | (cnt[4] & (n0q_m > n1q_m));

  ////////////////////////////////////
  // pipe line alignment
  ////////////////////////////////////
  reg       vde_q, vde_reg;
  reg       ade_q, ade_reg;
  reg       ade_reg_q, ade_reg_qq;
  reg       c0_q, c1_q;
  reg       c0_reg, c1_reg;
  reg [3:0] adin_q, adin_reg;
  reg [8:0] q_m_reg;

  always @ (posedge clkin) begin
    vde_q      <=#1 vde;
    vde_reg    <=#1 vde_q;

    ade_q      <=#1 ade;
    ade_reg    <=#1 ade_q;
    ade_reg_q  <=#1 ade_reg;
    ade_reg_qq <=#1 ade_reg_q;

    c0_q    <=#1 c0;
    c0_reg  <=#1 c0_q;
    c1_q    <=#1 c1;
    c1_reg  <=#1 c1_q;

    adin_q     <=#1 adin;
    adin_reg   <=#1 adin_q;

    q_m_reg    <=#1 q_m;
  end

  wire digbnd; //data island guard band period
  assign digbnd = (ade & !ade_reg) | (!ade_reg & ade_reg_qq);

  wire ade_vld;
  wire [3:0] adin_vld;

  generate
    if(CHANNEL == "BLUE") begin
      assign ade_vld = ade | ade_reg | ade_reg_qq;
      assign adin_vld = (digbnd) ? {1'b1, 1'b1, c1_reg, c0_reg} : {adin_reg[3], adin_reg[2], c1_reg, c0_reg};
    end else begin
      assign ade_vld = ade_reg;
      assign adin_vld = adin_reg;
    end
  endgenerate


  ///////////////////////////////
  // 10-bit out
  // disparity counter
  ///////////////////////////////
  always @ (posedge clkin or posedge rstin) begin
    if(rstin) begin
      dout <= 10'h0;
      cnt <= 5'h0;
    end else begin //TMDS
      if (vde_reg) begin //Video Data Period
        if(decision2) begin
          dout[9]   <=#1 ~q_m_reg[8]; 
          dout[8]   <=#1 q_m_reg[8]; 
          dout[7:0] <=#1 (q_m_reg[8]) ? q_m_reg[7:0] : ~q_m_reg[7:0];

          cnt <=#1 (~q_m_reg[8]) ? (cnt + n0q_m - n1q_m) : (cnt + n1q_m - n0q_m);
        end else begin
          if(decision3) begin
            dout[9]   <=#1 1'b1;
            dout[8]   <=#1 q_m_reg[8];
            dout[7:0] <=#1 ~q_m_reg;

            cnt <=#1 cnt + {q_m_reg[8], 1'b0} + (n0q_m - n1q_m);
          end else begin
            dout[9]   <=#1 1'b0;
            dout[8]   <=#1 q_m_reg[8];
            dout[7:0] <=#1 q_m_reg[7:0];

            cnt <=#1 cnt - {~q_m_reg[8], 1'b0} + (n1q_m - n0q_m);
          end
        end
      end else begin
        if(vde && (MODE == "HDMI"))          //video guard band period
          dout <=#1 VIDEOGBND;
        else if(ade_vld && (MODE == "HDMI")) //Aux/Audio Data Period
          case (adin_vld) //TERC4
            4'b0000: dout <=#1 10'b1010011100;
            4'b0001: dout <=#1 10'b1001100011;
            4'b0010: dout <=#1 10'b1011100100;
            4'b0011: dout <=#1 10'b1011100010;
            4'b0100: dout <=#1 10'b0101110001;
            4'b0101: dout <=#1 10'b0100011110;
            4'b0110: dout <=#1 10'b0110001110;
            4'b0111: dout <=#1 10'b0100111100;
            4'b1000: dout <=#1 10'b1011001100;
            4'b1001: dout <=#1 10'b0100111001;
            4'b1010: dout <=#1 10'b0110011100;
            4'b1011: dout <=#1 10'b1011000110;
            4'b1100: dout <=#1 10'b1010001110;
            4'b1101: dout <=#1 10'b1001110001;
            4'b1110: dout <=#1 10'b0101100011;
            default: dout <=#1 10'b1011000011;
          endcase
        else if((ade | ade_reg_qq) && (CHANNEL != "BLUE") && (MODE == "HDMI")) //data island guard band period
          dout <=#1 DILNDGBND;
        else            //preample period
          case ({c1_reg, c0_reg})
            2'b00:   dout <=#1 CTRLTOKEN0;
            2'b01:   dout <=#1 CTRLTOKEN1;
            2'b10:   dout <=#1 CTRLTOKEN2;
            default: dout <=#1 CTRLTOKEN3;
          endcase

        cnt <=#1 5'h0;
      end
    end
  end
  
endmodule
