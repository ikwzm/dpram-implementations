# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_ALEN_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_ID_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RAM_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RAM_RN" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RAM_WN" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WRITE_MODE" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_ADDR_WIDTH { PARAM_VALUE.C_ADDR_WIDTH } {
	# Procedure called to update C_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ADDR_WIDTH { PARAM_VALUE.C_ADDR_WIDTH } {
	# Procedure called to validate C_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_ALEN_WIDTH { PARAM_VALUE.C_ALEN_WIDTH } {
	# Procedure called to update C_ALEN_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ALEN_WIDTH { PARAM_VALUE.C_ALEN_WIDTH } {
	# Procedure called to validate C_ALEN_WIDTH
	return true
}

proc update_PARAM_VALUE.C_DATA_WIDTH { PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to update C_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DATA_WIDTH { PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to validate C_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_ID_WIDTH { PARAM_VALUE.C_ID_WIDTH } {
	# Procedure called to update C_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ID_WIDTH { PARAM_VALUE.C_ID_WIDTH } {
	# Procedure called to validate C_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.RAM_ADDR_WIDTH { PARAM_VALUE.RAM_ADDR_WIDTH } {
	# Procedure called to update RAM_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RAM_ADDR_WIDTH { PARAM_VALUE.RAM_ADDR_WIDTH } {
	# Procedure called to validate RAM_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.RAM_RN { PARAM_VALUE.RAM_RN } {
	# Procedure called to update RAM_RN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RAM_RN { PARAM_VALUE.RAM_RN } {
	# Procedure called to validate RAM_RN
	return true
}

proc update_PARAM_VALUE.RAM_WN { PARAM_VALUE.RAM_WN } {
	# Procedure called to update RAM_WN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RAM_WN { PARAM_VALUE.RAM_WN } {
	# Procedure called to validate RAM_WN
	return true
}

proc update_PARAM_VALUE.WRITE_MODE { PARAM_VALUE.WRITE_MODE } {
	# Procedure called to update WRITE_MODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WRITE_MODE { PARAM_VALUE.WRITE_MODE } {
	# Procedure called to validate WRITE_MODE
	return true
}


proc update_MODELPARAM_VALUE.C_ADDR_WIDTH { MODELPARAM_VALUE.C_ADDR_WIDTH PARAM_VALUE.C_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_ALEN_WIDTH { MODELPARAM_VALUE.C_ALEN_WIDTH PARAM_VALUE.C_ALEN_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_ALEN_WIDTH}] ${MODELPARAM_VALUE.C_ALEN_WIDTH}
}

proc update_MODELPARAM_VALUE.C_ID_WIDTH { MODELPARAM_VALUE.C_ID_WIDTH PARAM_VALUE.C_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_ID_WIDTH}] ${MODELPARAM_VALUE.C_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_DATA_WIDTH { MODELPARAM_VALUE.C_DATA_WIDTH PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_DATA_WIDTH}] ${MODELPARAM_VALUE.C_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.RAM_ADDR_WIDTH { MODELPARAM_VALUE.RAM_ADDR_WIDTH PARAM_VALUE.RAM_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RAM_ADDR_WIDTH}] ${MODELPARAM_VALUE.RAM_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.RAM_RN { MODELPARAM_VALUE.RAM_RN PARAM_VALUE.RAM_RN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RAM_RN}] ${MODELPARAM_VALUE.RAM_RN}
}

proc update_MODELPARAM_VALUE.RAM_WN { MODELPARAM_VALUE.RAM_WN PARAM_VALUE.RAM_WN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RAM_WN}] ${MODELPARAM_VALUE.RAM_WN}
}

proc update_MODELPARAM_VALUE.WRITE_MODE { MODELPARAM_VALUE.WRITE_MODE PARAM_VALUE.WRITE_MODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WRITE_MODE}] ${MODELPARAM_VALUE.WRITE_MODE}
}

