`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2020 03:17:47 PM
// Design Name: 
// Module Name: display_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module display_controller # (
  parameter integer C_S_AXI_DATA_WIDTH	= 32,  // Width of S_AXI data bus
  parameter C_DATA_WIDTH = 32,  // Data width of bus with RGB
  parameter C_RED_WIDTH = 8,	// Width of Red Channel
  parameter C_GREEN_WIDTH = 8,  // Width of Green Channel
  parameter C_BLUE_WIDTH = 8	// Width of Blue Channel
) (
  input pix_clk,
  input pix_clk_locked,
  input areset_n,

  input [C_S_AXI_DATA_WIDTH-1:0] ctrl,
  input [C_S_AXI_DATA_WIDTH-1:0] test_data,

  input [C_S_AXI_DATA_WIDTH-1:0] hs_end,
  input [C_S_AXI_DATA_WIDTH-1:0] hbp_end,
  input [C_S_AXI_DATA_WIDTH-1:0] hfp_begin,
  input [C_S_AXI_DATA_WIDTH-1:0] hline_end,

  input [C_S_AXI_DATA_WIDTH-1:0] vs_end,
  input [C_S_AXI_DATA_WIDTH-1:0] vbp_end,
  input [C_S_AXI_DATA_WIDTH-1:0] vfp_begin,
  input [C_S_AXI_DATA_WIDTH-1:0] vline_end,

  // fit to XSVI standard port
  output [C_DATA_WIDTH-1:0] pix_data,  // Width of RGB data bus
  output hsync,                        // Hsync Data
  output vsync,                        // Vsync Data
  output vde                           // Video Data enable
);

localparam DISP_CTRL_EN = 32'h1; // bit 0 of CTRL register

wire areset_n_int;

assign areset_n_int = areset_n & pix_clk_locked;

reg [11:0] hcount = 32'h0;
reg [11:0] vcount = 32'h0;

always @(posedge pix_clk or negedge areset_n_int)
begin
  if (! areset_n_int)
  begin
    hcount <= 'h0;
    vcount <= 'h0;
  end
  else if (ctrl & DISP_CTRL_EN != DISP_CTRL_EN)
  begin
    hcount <= 'h0;
    vcount <= 'h0;
  end
  else
  begin
      if (hcount == hline_end - 1'b1)
      begin
          hcount <= 'h0;
          if (vcount == vline_end - 1'b1)
              vcount <= 'h0;
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

reg hsync_reg;
reg vsync_reg;
reg vde_reg;
wire vde_comb;

assign vde_comb = (hcount >= hbp_end &&
                   hcount < hfp_begin &&
                   vcount >= vbp_end &&
                   vcount < vfp_begin) ? 1'b1: 1'b0;

always @(posedge pix_clk or negedge areset_n_int)
begin
  if (! areset_n_int) begin
    hsync_reg <= 1'b0;
    vsync_reg <= 1'b0;
    vde_reg <= 1'b0;
  end else if (ctrl & DISP_CTRL_EN != DISP_CTRL_EN) begin
    hsync_reg <= 1'b0;
    vsync_reg <= 1'b0;
    vde_reg <= 1'b0;
  end else begin
    hsync_reg <= (hcount >= 0 && hcount < hs_end) ? 1'b1 : 1'b0;
    vsync_reg <= (vcount >= 0 && vcount < vs_end) ? 1'b1 : 1'b0;
    vde_reg <= vde_comb;
  end
end

assign hsync = hsync_reg;
assign vsync = vsync_reg;
assign vde = vde_reg;

// Default pattern
wire [7:0] pattern;

assign pattern = ctrl[15:8];

// Synced test video data
reg [C_DATA_WIDTH-1:0] test_data_sync;

always @(posedge pix_clk or negedge areset_n_int)
begin
  if (! areset_n_int) begin
    test_data_sync <= 'd0;
  end else if (vcount == 'd0) begin
    test_data_sync <= test_data;
  end else begin
    test_data_sync <= test_data_sync;
  end
end

// Pattern selection
reg [C_DATA_WIDTH-1:0] pix_data_reg;

always @(posedge pix_clk or negedge areset_n_int)
begin
  if (! areset_n_int) begin
    pix_data_reg <= 'd0;
  end else if (ctrl & DISP_CTRL_EN != DISP_CTRL_EN) begin
    pix_data_reg <= 'd0;
  end else begin
    pix_data_reg <= vde_comb ? test_data_sync : 'd0;
  end
end

assign pix_data = pix_data_reg;

endmodule
