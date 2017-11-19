# BTN-0
set_property PACKAGE_PIN W14 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

# SYSCLK 100MHz
set_property PACKAGE_PIN H16 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk -waveform {0.000 4.000} -add [get_ports clk]

set_property PACKAGE_PIN M15 [get_ports {sw[7]}]
set_property PACKAGE_PIN L15 [get_ports {sw[6]}]
set_property PACKAGE_PIN P14 [get_ports {sw[5]}]
set_property PACKAGE_PIN R14 [get_ports {sw[4]}]
set_property PACKAGE_PIN N16 [get_ports {sw[3]}]
set_property PACKAGE_PIN R16 [get_ports {sw[2]}]
set_property PACKAGE_PIN U20 [get_ports {sw[1]}]
set_property PACKAGE_PIN R17 [get_ports {sw[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]

set_property PACKAGE_PIN U18 [get_ports {TMDS_CLK_P}]
set_property PACKAGE_PIN U19 [get_ports {TMDS_CLK_N}]

set_property PACKAGE_PIN P19 [get_ports {TMDS_DATA_N[2]}]
set_property PACKAGE_PIN N18 [get_ports {TMDS_DATA_P[2]}]
set_property PACKAGE_PIN P18 [get_ports {TMDS_DATA_N[1]}]
set_property PACKAGE_PIN N17 [get_ports {TMDS_DATA_P[1]}]
set_property PACKAGE_PIN V18 [get_ports {TMDS_DATA_N[0]}]
set_property PACKAGE_PIN V17 [get_ports {TMDS_DATA_P[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS*}]

set_property PACKAGE_PIN P16 [get_ports hdmi_tx_hpd]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_tx_hpd]

set_property PACKAGE_PIN T16 [get_ports {vga_red[3]}]
set_property PACKAGE_PIN V16 [get_ports {vga_red[2]}]
set_property PACKAGE_PIN W15 [get_ports {vga_red[1]}]
set_property PACKAGE_PIN V15 [get_ports {vga_red[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_red[*]}]

set_property PACKAGE_PIN U15 [get_ports {vga_green[3]}]
set_property PACKAGE_PIN U14 [get_ports {vga_green[2]}]
set_property PACKAGE_PIN V13 [get_ports {vga_green[1]}]
set_property PACKAGE_PIN T15 [get_ports {vga_green[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_green[*]}]

set_property PACKAGE_PIN V12 [get_ports {vga_blue[3]}]
set_property PACKAGE_PIN U12 [get_ports {vga_blue[2]}]
set_property PACKAGE_PIN T14 [get_ports {vga_blue[1]}]
set_property PACKAGE_PIN T11 [get_ports {vga_blue[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_blue[*]}]

set_property PACKAGE_PIN T12 [get_ports vga_hsync]
set_property IOSTANDARD LVCMOS33 [get_ports vga_hsync]
set_property PACKAGE_PIN T10 [get_ports vga_vsync]
set_property IOSTANDARD LVCMOS33 [get_ports vga_vsync]

# The VGA outputs are turned into an analog voltage by virtue of a resistor
# network, so the flip flops driving these must sit in the IOBs to minimize
# timing skew. The RTL code should handle this, but the constraint below
# is there to fail if something goes wrong about this.
set_false_path -setup -to [get_ports vga*]
set_output_delay 5.500 [get_ports vga*]
