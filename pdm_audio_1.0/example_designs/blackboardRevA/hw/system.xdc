# speaker pin
set_property PACKAGE_PIN G18 [get_ports {pdm_speaker_l}]
set_property IOSTANDARD LVCMOS33 [get_ports {pdm_speaker_l}]

# MIC pin
set_property PACKAGE_PIN L14 [get_ports {pdm_mic}]
set_property IOSTANDARD LVCMOS33 [get_ports {pdm_mic}]

set_property PACKAGE_PIN N15 [get_ports {pdm_mic_mclk}]
set_property IOSTANDARD LVCMOS33 [get_ports {pdm_mic_mclk}]

# JA1P (PmodA 1) rewired to ESP32 BOOT0
set_property PACKAGE_PIN F16 [get_ports {ESP32_Ctrl_tri_io[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ESP32_Ctrl_tri_io[0]}]
# JA1N (PmodA 2) rewired to ESP32 EN
set_property PACKAGE_PIN F17 [get_ports {ESP32_Ctrl_tri_io[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ESP32_Ctrl_tri_io[1]}]
# JA2P (PmodA 3)
set_property PACKAGE_PIN G19 [get_ports {ESP32_Uart_txd}]
set_property IOSTANDARD LVCMOS33 [get_ports {ESP32_Uart_txd}]
# JA2N (PmodA 4)
set_property PACKAGE_PIN G20 [get_ports {ESP32_Uart_rxd}]
set_property IOSTANDARD LVCMOS33 [get_ports {ESP32_Uart_rxd}]