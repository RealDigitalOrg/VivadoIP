//////////////////////////////////////////////////////////////////////////////////
// Module: spi_bridge
// Author: Tinghui Wang
//
// Copyright @ 2019 RealDigital.org
//
// Description:
//   Bridging the SPI interface of STMicroelectronics LSM9DS1 iNEMO inertial
//   module and the Zynq PS SPI interface.
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

module spi_bridge(
    // SPI Slave Interface
    input M_SPI_SCLK_O,
    input M_SPI_SCLK_TN,
    output M_SPI_SCLK_I,
    input M_SPI_MOSI_O,
    input M_SPI_MOSI_TN,
    output M_SPI_MOSI_I,
    output M_SPI_MISO_I,
    input M_SPI_MISO_TN,
    input M_SPI_MISO_O,
    input M_SPI_SS_TN,
    input M_SPI_SS_O,
    input M_SPI_SS1_O,
    input M_SPI_SS2_O,
    output M_SPI_SS_I,
    // LSM9DS1 Interface
    inout SCK_AGM,
    inout MOSI_AGM,
    input MISO_AG,
    input MISO_M,
    inout SS_AG,
    inout SS_M
    );

// Tri-state logic for SPI CLK
assign SCK_AGM = (M_SPI_SCLK_TN == 1'b0) ? M_SPI_SCLK_O : 1'bZ;
assign M_SPI_SCLK_I = 1'b0;

// Tri-state Logic for SPI MOSI
assign MOSI_AGM = (M_SPI_MOSI_TN == 1'b0) ? M_SPI_MOSI_O : 1'bZ;
assign M_SPI_MOSI_I = 1'b0;

// Mux Logic for MISO, MISO_TN/MISO_O - nc
assign M_SPI_MISO_I = (M_SPI_SS_O == 1'b0 && M_SPI_SS_TN == 1'b0) ? MISO_AG : 
    ((M_SPI_SS1_O == 1'b0 && M_SPI_SS_TN == 1'b0) ? MISO_M : 1'b1);

// Tri-state for SS
// SS0 - SS_AG
// SS1 - SS_M
// SS2 - nc
assign SS_AG = (M_SPI_SS_TN == 1'b0) ? M_SPI_SS_O : 1'bZ;
assign SS_M = (M_SPI_SS_TN == 1'b0) ? M_SPI_SS1_O : 1'bZ;

// M_SPI_SS_I must be tied high in the PL stream to ensure that the PS-PL level 
// shifters are enabled. See UG585 Zynq TRM Chapter 17.
assign M_SPI_SS_I = 1'b1;

endmodule

