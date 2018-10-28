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
# @file base.tcl
#
# Vivado tcl script to generate basic board design
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

set ip_repo_path        {$script_folder/../../../}
set bd_name             {system}
set device              {xc7z007sclg400-1}
set project_name        {pdm_audio_proj}

# Create project
set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
    create_project $project_name ./$project_name -part $device
}

# Set IP Repository
set_property ip_repo_paths ${ip_repo_path} [current_fileset]
update_ip_catalog -rebuild

# Change design name
variable design_name
set design_name "system"

# Create block design
set current_bd [create_bd_design $design_name]
set parentCell [get_bd_cells /]

proc apply_ps_presets { cell presetFile } {
    source $presetFile
    set presets [apply_preset 0]
    foreach {k v} $presets {
        if { ![info exists preset_list] } {
            set preset_list [dict create $k $v]
        } else {
            dict set preset_list $k $v
        }
    }

    set_property -dict $preset_list $cell 
}

proc create_ps { parentCell cellName } {
	upvar 1 script_folder script_folder
    # Add Zynq processing system
    set ps_cell [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7 $cellName ]
    apply_ps_presets $ps_cell ${script_folder}/blackboard_ps_presets.tcl
    apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" Master "Disable" Slave "Disable" } $ps_cell 
}

# Create processing system
create_ps $parentCell "processing_system7_0"

# Create instance: pdm_audio, and set properties
set pdm_audio [ create_bd_cell -type ip -vlnv realdigital.org:realdigital:pdm_audio:1.0 pdm_audio ]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} } [get_bd_intf_pins pdm_audio/S_AXI] 
set pdm_mic [ create_bd_port -dir I pdm_mic ]
set pdm_mic_mclk [ create_bd_port -dir O pdm_mic_mclk ]
set pdm_speaker_l [ create_bd_port -dir IO pdm_speaker_l ]
set pdm_speaker_r [ create_bd_port -dir IO pdm_speaker_r ]
connect_bd_net -net net_pdm_speaker_r [get_bd_ports pdm_speaker_r] [get_bd_pins pdm_audio/pdm_speaker_r]
connect_bd_net -net net_pdm_speaker_l [get_bd_ports pdm_speaker_l] [get_bd_pins pdm_audio/pdm_speaker_l]
connect_bd_net -net net_pdm_mic_mclk [get_bd_ports pdm_mic_mclk] [get_bd_pins pdm_audio/pdm_mic_mclk]
connect_bd_net -net net_pdm_mic_data [get_bd_ports pdm_mic] [get_bd_pins pdm_audio/pdm_mic]
connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins pdm_audio/pdm_mclk] [get_bd_pins processing_system7_0/FCLK_CLK1]

# Create instance: intr_concat, and set properties
set intr_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat intr_concat ]
set_property -dict [ list \
    CONFIG.NUM_PORTS {3} \
] $intr_concat
connect_bd_net -net pdm_audio_0_spkLIntr [get_bd_pins intr_concat/In0] [get_bd_pins pdm_audio/spkLIntr]
connect_bd_net -net pdm_audio_0_spkRIntr [get_bd_pins intr_concat/In1] [get_bd_pins pdm_audio/spkRIntr]
connect_bd_net -net pdm_audio_0_micIntr [get_bd_pins intr_concat/In2] [get_bd_pins pdm_audio/micIntr]
connect_bd_net -net xlconcat_0_dout [get_bd_pins intr_concat/dout] [get_bd_pins processing_system7_0/IRQ_F2P]

# Save block design
save_bd_design
set bd_filename [get_property FILE_NAME [current_bd_design]]

# Close block design
close_bd_design $current_bd

# Set synthesize option to global 
set_property synth_checkpoint_mode None [get_files $bd_filename]

# Create HDL wrapper
set wrapper_file [make_wrapper -files [get_files $bd_filename] -top]

# Create source set
if {[string equal [get_filesets -quiet sources_1] ""]} {
    create_fileset -srcset sources_1
}
add_files -fileset sources_1 $wrapper_file

# Add constraints
if {[string equal [get_filesets -quiet constrs_1] ""]} {
    create_fileset -constrset constrs_1
}
set obj [get_filesets constrs_1]
set files [list \
	"[file normalize "constraints/system.xdc"]" \
	"[file normalize "constraints/blackboard_pdm_audio.xdc"]" \
]
set file_imported [import_files -fileset constrs_1 $files]

