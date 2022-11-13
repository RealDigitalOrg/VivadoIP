# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_RED_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_GREEN_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_BLUE_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXI_DATA_WIDTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_S_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXI_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXI_HIGHADDR" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_BLUE_WIDTH { PARAM_VALUE.C_BLUE_WIDTH } {
	# Procedure called to update C_BLUE_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_BLUE_WIDTH { PARAM_VALUE.C_BLUE_WIDTH } {
	# Procedure called to validate C_BLUE_WIDTH
	return true
}

proc update_PARAM_VALUE.C_DATA_WIDTH { PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to update C_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DATA_WIDTH { PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to validate C_DATA_WIDTH
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

proc update_PARAM_VALUE.HBP_END_DEFAULT { PARAM_VALUE.HBP_END_DEFAULT } {
	# Procedure called to update HBP_END_DEFAULT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HBP_END_DEFAULT { PARAM_VALUE.HBP_END_DEFAULT } {
	# Procedure called to validate HBP_END_DEFAULT
	return true
}

proc update_PARAM_VALUE.HFP_BEGIN_DEFAULT { PARAM_VALUE.HFP_BEGIN_DEFAULT } {
	# Procedure called to update HFP_BEGIN_DEFAULT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HFP_BEGIN_DEFAULT { PARAM_VALUE.HFP_BEGIN_DEFAULT } {
	# Procedure called to validate HFP_BEGIN_DEFAULT
	return true
}

proc update_PARAM_VALUE.HLINE_END_DEFAULT { PARAM_VALUE.HLINE_END_DEFAULT } {
	# Procedure called to update HLINE_END_DEFAULT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HLINE_END_DEFAULT { PARAM_VALUE.HLINE_END_DEFAULT } {
	# Procedure called to validate HLINE_END_DEFAULT
	return true
}

proc update_PARAM_VALUE.HS_END_DEFAULT { PARAM_VALUE.HS_END_DEFAULT } {
	# Procedure called to update HS_END_DEFAULT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HS_END_DEFAULT { PARAM_VALUE.HS_END_DEFAULT } {
	# Procedure called to validate HS_END_DEFAULT
	return true
}

proc update_PARAM_VALUE.VBP_END_DEFAULT { PARAM_VALUE.VBP_END_DEFAULT } {
	# Procedure called to update VBP_END_DEFAULT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VBP_END_DEFAULT { PARAM_VALUE.VBP_END_DEFAULT } {
	# Procedure called to validate VBP_END_DEFAULT
	return true
}

proc update_PARAM_VALUE.VFP_BEGIN_DEFAULT { PARAM_VALUE.VFP_BEGIN_DEFAULT } {
	# Procedure called to update VFP_BEGIN_DEFAULT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VFP_BEGIN_DEFAULT { PARAM_VALUE.VFP_BEGIN_DEFAULT } {
	# Procedure called to validate VFP_BEGIN_DEFAULT
	return true
}

proc update_PARAM_VALUE.VLINE_END_DEFAULT { PARAM_VALUE.VLINE_END_DEFAULT } {
	# Procedure called to update VLINE_END_DEFAULT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VLINE_END_DEFAULT { PARAM_VALUE.VLINE_END_DEFAULT } {
	# Procedure called to validate VLINE_END_DEFAULT
	return true
}

proc update_PARAM_VALUE.VS_END_DEFAULT { PARAM_VALUE.VS_END_DEFAULT } {
	# Procedure called to update VS_END_DEFAULT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VS_END_DEFAULT { PARAM_VALUE.VS_END_DEFAULT } {
	# Procedure called to validate VS_END_DEFAULT
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

proc update_MODELPARAM_VALUE.HS_END_DEFAULT { MODELPARAM_VALUE.HS_END_DEFAULT PARAM_VALUE.HS_END_DEFAULT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HS_END_DEFAULT}] ${MODELPARAM_VALUE.HS_END_DEFAULT}
}

proc update_MODELPARAM_VALUE.HBP_END_DEFAULT { MODELPARAM_VALUE.HBP_END_DEFAULT PARAM_VALUE.HBP_END_DEFAULT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HBP_END_DEFAULT}] ${MODELPARAM_VALUE.HBP_END_DEFAULT}
}

proc update_MODELPARAM_VALUE.HFP_BEGIN_DEFAULT { MODELPARAM_VALUE.HFP_BEGIN_DEFAULT PARAM_VALUE.HFP_BEGIN_DEFAULT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HFP_BEGIN_DEFAULT}] ${MODELPARAM_VALUE.HFP_BEGIN_DEFAULT}
}

proc update_MODELPARAM_VALUE.HLINE_END_DEFAULT { MODELPARAM_VALUE.HLINE_END_DEFAULT PARAM_VALUE.HLINE_END_DEFAULT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HLINE_END_DEFAULT}] ${MODELPARAM_VALUE.HLINE_END_DEFAULT}
}

proc update_MODELPARAM_VALUE.VS_END_DEFAULT { MODELPARAM_VALUE.VS_END_DEFAULT PARAM_VALUE.VS_END_DEFAULT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VS_END_DEFAULT}] ${MODELPARAM_VALUE.VS_END_DEFAULT}
}

proc update_MODELPARAM_VALUE.VBP_END_DEFAULT { MODELPARAM_VALUE.VBP_END_DEFAULT PARAM_VALUE.VBP_END_DEFAULT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VBP_END_DEFAULT}] ${MODELPARAM_VALUE.VBP_END_DEFAULT}
}

proc update_MODELPARAM_VALUE.VFP_BEGIN_DEFAULT { MODELPARAM_VALUE.VFP_BEGIN_DEFAULT PARAM_VALUE.VFP_BEGIN_DEFAULT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VFP_BEGIN_DEFAULT}] ${MODELPARAM_VALUE.VFP_BEGIN_DEFAULT}
}

proc update_MODELPARAM_VALUE.VLINE_END_DEFAULT { MODELPARAM_VALUE.VLINE_END_DEFAULT PARAM_VALUE.VLINE_END_DEFAULT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VLINE_END_DEFAULT}] ${MODELPARAM_VALUE.VLINE_END_DEFAULT}
}

proc update_MODELPARAM_VALUE.C_DATA_WIDTH { MODELPARAM_VALUE.C_DATA_WIDTH PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_DATA_WIDTH}] ${MODELPARAM_VALUE.C_DATA_WIDTH}
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

