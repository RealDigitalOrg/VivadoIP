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

