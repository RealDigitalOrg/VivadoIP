
`timescale 1 ns / 1 ps

  module display_pattern_generator_v1_0 #
  (
    // Users to add parameters here
    // Initialize video configuration register to 720P
    parameter HS_END_DEFAULT = 40,
    parameter HBP_END_DEFAULT = 260,
    parameter HFP_BEGIN_DEFAULT = 1540,
    parameter HLINE_END_DEFAULT = 1650,

    parameter VS_END_DEFAULT = 5,
    parameter VBP_END_DEFAULT = 25,
    parameter VFP_BEGIN_DEFAULT = 745,
    parameter VLINE_END_DEFAULT = 750,

    parameter C_DATA_WIDTH = 32,  // Data width of bus with RGB
    parameter C_RED_WIDTH = 8,	// Width of Red Channel
    parameter C_GREEN_WIDTH = 8,  // Width of Green Channel
    parameter C_BLUE_WIDTH = 8,	// Width of Blue Channel
    // User parameters ends
    // Do not modify the parameters beyond this line


    // Parameters of Axi Slave Bus Interface S_AXI
    parameter integer C_S_AXI_DATA_WIDTH	= 32,
    parameter integer C_S_AXI_ADDR_WIDTH	= 7
  )
  (
    // Users to add ports here
    input pix_clk,
    input pix_clk_locked,
    input areset_n,

    // fit to XSVI standard port
    output [C_DATA_WIDTH-1:0] pix_data,  // Width of RGB data bus
    output hsync,                        // Hsync Data
    output vsync,                        // Vsync Data
    output vde,                          // Video Data enable
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

wire [C_S_AXI_DATA_WIDTH-1:0] ctrl;
wire [C_S_AXI_DATA_WIDTH-1:0] test_data;
wire [C_S_AXI_DATA_WIDTH-1:0] hs_end;
wire [C_S_AXI_DATA_WIDTH-1:0] hbp_end;
wire [C_S_AXI_DATA_WIDTH-1:0] hfp_begin;
wire [C_S_AXI_DATA_WIDTH-1:0] hline_end;
wire [C_S_AXI_DATA_WIDTH-1:0] vs_end;
wire [C_S_AXI_DATA_WIDTH-1:0] vbp_end;
wire [C_S_AXI_DATA_WIDTH-1:0] vfp_begin;
wire [C_S_AXI_DATA_WIDTH-1:0] vline_end;

// Instantiation of Axi Bus Interface S_AXI
  display_pattern_generator_v1_0_S_AXI # (
    .HS_END_DEFAULT(HS_END_DEFAULT),
    .HBP_END_DEFAULT(HBP_END_DEFAULT),
    .HFP_BEGIN_DEFAULT(HFP_BEGIN_DEFAULT),
    .HLINE_END_DEFAULT(HLINE_END_DEFAULT),
    .VS_END_DEFAULT(VS_END_DEFAULT),
    .VBP_END_DEFAULT(VBP_END_DEFAULT),
    .VFP_BEGIN_DEFAULT(VFP_BEGIN_DEFAULT),
    .VLINE_END_DEFAULT(VLINE_END_DEFAULT),
    .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
  ) display_pattern_generator_v1_0_S_AXI_inst (
    .ctrl(ctrl),
    .test_data(test_data),
    .hs_end(hs_end),
    .hbp_end(hbp_end),
    .hfp_begin(hfp_begin),
    .hline_end(hline_end),
    .vs_end(vs_end),
    .vbp_end(vbp_end),
    .vfp_begin(vfp_begin),
    .vline_end(vline_end),
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
  display_controller # (
    .C_DATA_WIDTH(C_DATA_WIDTH),
    .C_RED_WIDTH(C_RED_WIDTH),
    .C_GREEN_WIDTH(C_GREEN_WIDTH),
    .C_BLUE_WIDTH(C_BLUE_WIDTH),
    .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH)
  ) display_controller_inst (
    .pix_clk(pix_clk),
    .pix_clk_locked(pix_clk_locked),
    .areset_n(areset_n),
  
    .ctrl(ctrl),
    .test_data(test_data),
    .hs_end(hs_end),
    .hbp_end(hbp_end),
    .hfp_begin(hfp_begin),
    .hline_end(hline_end),
    .vs_end(vs_end),
    .vbp_end(vbp_end),
    .vfp_begin(vfp_begin),
    .vline_end(vline_end),

    .pix_data(pix_data),
    .hsync(hsync),
    .vsync(vsync),
    .vde(vde)
  );
  // User logic ends

  endmodule
