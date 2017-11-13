# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "SPEAKER_L_EN"
  ipgui::add_param $IPINST -name "SPEAKER_R_EN"
  ipgui::add_param $IPINST -name "MIC_EN"
  ipgui::add_param $IPINST -name "pcmResetCyclesParam"

}

proc update_PARAM_VALUE.MIC_EN { PARAM_VALUE.MIC_EN } {
	# Procedure called to update MIC_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MIC_EN { PARAM_VALUE.MIC_EN } {
	# Procedure called to validate MIC_EN
	return true
}

proc update_PARAM_VALUE.SPEAKER_L_EN { PARAM_VALUE.SPEAKER_L_EN } {
	# Procedure called to update SPEAKER_L_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SPEAKER_L_EN { PARAM_VALUE.SPEAKER_L_EN } {
	# Procedure called to validate SPEAKER_L_EN
	return true
}

proc update_PARAM_VALUE.SPEAKER_R_EN { PARAM_VALUE.SPEAKER_R_EN } {
	# Procedure called to update SPEAKER_R_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SPEAKER_R_EN { PARAM_VALUE.SPEAKER_R_EN } {
	# Procedure called to validate SPEAKER_R_EN
	return true
}

proc update_PARAM_VALUE.pcmResetCyclesParam { PARAM_VALUE.pcmResetCyclesParam } {
	# Procedure called to update pcmResetCyclesParam when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.pcmResetCyclesParam { PARAM_VALUE.pcmResetCyclesParam } {
	# Procedure called to validate pcmResetCyclesParam
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

proc update_MODELPARAM_VALUE.SPEAKER_L_EN { MODELPARAM_VALUE.SPEAKER_L_EN PARAM_VALUE.SPEAKER_L_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SPEAKER_L_EN}] ${MODELPARAM_VALUE.SPEAKER_L_EN}
}

proc update_MODELPARAM_VALUE.SPEAKER_R_EN { MODELPARAM_VALUE.SPEAKER_R_EN PARAM_VALUE.SPEAKER_R_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SPEAKER_R_EN}] ${MODELPARAM_VALUE.SPEAKER_R_EN}
}

proc update_MODELPARAM_VALUE.MIC_EN { MODELPARAM_VALUE.MIC_EN PARAM_VALUE.MIC_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MIC_EN}] ${MODELPARAM_VALUE.MIC_EN}
}

proc update_MODELPARAM_VALUE.pcmResetCyclesParam { MODELPARAM_VALUE.pcmResetCyclesParam PARAM_VALUE.pcmResetCyclesParam } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.pcmResetCyclesParam}] ${MODELPARAM_VALUE.pcmResetCyclesParam}
}

