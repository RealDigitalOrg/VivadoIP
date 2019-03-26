# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "C_NUM_DIGITS"
  ipgui::add_param $IPINST -name "C_CLK_FREQ"
  ipgui::add_param $IPINST -name "C_SCAN_FREQ"
  ipgui::add_param $IPINST -name "C_CATHODE_POLARITY" -widget comboBox
  ipgui::add_param $IPINST -name "C_ANODE_POLARITY" -widget comboBox

}

proc update_PARAM_VALUE.C_ANODE_POLARITY { PARAM_VALUE.C_ANODE_POLARITY } {
	# Procedure called to update C_ANODE_POLARITY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ANODE_POLARITY { PARAM_VALUE.C_ANODE_POLARITY } {
	# Procedure called to validate C_ANODE_POLARITY
	return true
}

proc update_PARAM_VALUE.C_CATHODE_POLARITY { PARAM_VALUE.C_CATHODE_POLARITY } {
	# Procedure called to update C_CATHODE_POLARITY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_CATHODE_POLARITY { PARAM_VALUE.C_CATHODE_POLARITY } {
	# Procedure called to validate C_CATHODE_POLARITY
	return true
}

proc update_PARAM_VALUE.C_CLK_FREQ { PARAM_VALUE.C_CLK_FREQ } {
	# Procedure called to update C_CLK_FREQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_CLK_FREQ { PARAM_VALUE.C_CLK_FREQ } {
	# Procedure called to validate C_CLK_FREQ
	return true
}

proc update_PARAM_VALUE.C_NUM_DIGITS { PARAM_VALUE.C_NUM_DIGITS } {
	# Procedure called to update C_NUM_DIGITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_NUM_DIGITS { PARAM_VALUE.C_NUM_DIGITS } {
	# Procedure called to validate C_NUM_DIGITS
	return true
}

proc update_PARAM_VALUE.C_SCAN_FREQ { PARAM_VALUE.C_SCAN_FREQ } {
	# Procedure called to update C_SCAN_FREQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SCAN_FREQ { PARAM_VALUE.C_SCAN_FREQ } {
	# Procedure called to validate C_SCAN_FREQ
	return true
}

proc update_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to update C_S_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_BASEADDR { PARAM_VALUE.C_S_AXI_BASEADDR } {
	# Procedure called to update C_S_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_BASEADDR { PARAM_VALUE.C_S_AXI_BASEADDR } {
	# Procedure called to validate C_S_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S_AXI_HIGHADDR { PARAM_VALUE.C_S_AXI_HIGHADDR } {
	# Procedure called to update C_S_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_HIGHADDR { PARAM_VALUE.C_S_AXI_HIGHADDR } {
	# Procedure called to validate C_S_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_NUM_DIGITS { MODELPARAM_VALUE.C_NUM_DIGITS PARAM_VALUE.C_NUM_DIGITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_NUM_DIGITS}] ${MODELPARAM_VALUE.C_NUM_DIGITS}
}

proc update_MODELPARAM_VALUE.C_CLK_FREQ { MODELPARAM_VALUE.C_CLK_FREQ PARAM_VALUE.C_CLK_FREQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_CLK_FREQ}] ${MODELPARAM_VALUE.C_CLK_FREQ}
}

proc update_MODELPARAM_VALUE.C_SCAN_FREQ { MODELPARAM_VALUE.C_SCAN_FREQ PARAM_VALUE.C_SCAN_FREQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_SCAN_FREQ}] ${MODELPARAM_VALUE.C_SCAN_FREQ}
}

proc update_MODELPARAM_VALUE.C_CATHODE_POLARITY { MODELPARAM_VALUE.C_CATHODE_POLARITY PARAM_VALUE.C_CATHODE_POLARITY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_CATHODE_POLARITY}] ${MODELPARAM_VALUE.C_CATHODE_POLARITY}
}

proc update_MODELPARAM_VALUE.C_ANODE_POLARITY { MODELPARAM_VALUE.C_ANODE_POLARITY PARAM_VALUE.C_ANODE_POLARITY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_ANODE_POLARITY}] ${MODELPARAM_VALUE.C_ANODE_POLARITY}
}

