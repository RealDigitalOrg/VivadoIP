###############################################################################
#
# Copyright (c) 2018, RealDigital
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# 
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# 
# * Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
#
###############################################################################

###############################################################################
# @file project.tcl 
#
# Vivado tcl script to generate project
#
# <pre>
# MODIFICATION HISTORY:
# 
# Ver   Who  Date       Changes
# ----- ---- ---------- -------------------------------------------------------
# 1.00a TW   10/13/2018 initial release
#
# </pre>
#
###############################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

set origin_dir          "."
set device              {xc7z007sclg400-1}
set project_name        {hdmi_test}

# Create project and set project directory
set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
    create_project $project_name ./$project_name -part $device
}
set proj_dir [get_property directory [current_project]]

# Create sources set and add files
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

set src_set [get_filesets sources_1]
set files [list \
 "[file normalize "$script_folder/../../sim/clk_wiz_0/clk_wiz_0.xci"]"\
 "[file normalize "$script_folder/../../hdl/encode.v"]"\
 "[file normalize "$script_folder/../../hdl/hdmi_tx_v1_0.v"]"\
 "[file normalize "$script_folder/../../hdl/serdes_10_to_1.v"]"\
 "[file normalize "$script_folder/../../hdl/srldelay.v"]"\
 "[file normalize "$script_folder/../../sim/wrapper.v"]"\
]
add_files -norecurse -fileset $src_set $files
set_property -name "top" -value "wrapper" -objects $src_set

# Create constraints set and add files
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}
set con_set [get_filesets constrs_1]
set file "[file normalize "$script_folder/../constraints/blackboard_video.xdc"]"
set file_added [add_files -norecurse -fileset $con_set $file]

# Create simulation set and add files
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}
set sim_set [get_filesets sim_1]
set files [list \
 "[file normalize "$script_folder/../../sim/hdmi_tx_tb.v"]"\
]
add_files -norecurse -fileset $sim_set $files

