# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_BLUE_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_GREEN_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_RED_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MODE" -parent ${Page_0} -widget comboBox


}

proc update_PARAM_VALUE.C_BLUE_WIDTH { PARAM_VALUE.C_BLUE_WIDTH } {
	# Procedure called to update C_BLUE_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_BLUE_WIDTH { PARAM_VALUE.C_BLUE_WIDTH } {
	# Procedure called to validate C_BLUE_WIDTH
	return true
}

proc update_PARAM_VALUE.C_GREEN_WIDTH { PARAM_VALUE.C_GREEN_WIDTH } {
	# Procedure called to update C_GREEN_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_GREEN_WIDTH { PARAM_VALUE.C_GREEN_WIDTH } {
	# Procedure called to validate C_GREEN_WIDTH
	return true
}

proc update_PARAM_VALUE.C_RED_WIDTH { PARAM_VALUE.C_RED_WIDTH } {
	# Procedure called to update C_RED_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_RED_WIDTH { PARAM_VALUE.C_RED_WIDTH } {
	# Procedure called to validate C_RED_WIDTH
	return true
}

proc update_PARAM_VALUE.MODE { PARAM_VALUE.MODE } {
	# Procedure called to update MODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MODE { PARAM_VALUE.MODE } {
	# Procedure called to validate MODE
	return true
}


proc update_MODELPARAM_VALUE.MODE { MODELPARAM_VALUE.MODE PARAM_VALUE.MODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MODE}] ${MODELPARAM_VALUE.MODE}
}

proc update_MODELPARAM_VALUE.C_RED_WIDTH { MODELPARAM_VALUE.C_RED_WIDTH PARAM_VALUE.C_RED_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_RED_WIDTH}] ${MODELPARAM_VALUE.C_RED_WIDTH}
}

proc update_MODELPARAM_VALUE.C_GREEN_WIDTH { MODELPARAM_VALUE.C_GREEN_WIDTH PARAM_VALUE.C_GREEN_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_GREEN_WIDTH}] ${MODELPARAM_VALUE.C_GREEN_WIDTH}
}

proc update_MODELPARAM_VALUE.C_BLUE_WIDTH { MODELPARAM_VALUE.C_BLUE_WIDTH PARAM_VALUE.C_BLUE_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_BLUE_WIDTH}] ${MODELPARAM_VALUE.C_BLUE_WIDTH}
}

