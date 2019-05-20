###############################################################################
# File: create_project.tcl
# Author: Tinghui Wang
#
# Copyright (c) 2018-2019, RealDigital.org
#
# Description:
#   Create example design of PDM Audio IP Core targeting Blackboard Rev. D.
#
# History:
#   03/02/19: Initial release
#  
# License: BSD 3-Clause
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

namespace eval _tcl {
    proc get_script_folder {} {
	    set script_path [file normalize [info script]]
	    set script_folder [file dirname $script_path]
        return $script_folder
    }
}
variable script_folder
set script_folder [_tcl::get_script_folder]

variable script_file
set script_file "create_project.tcl"

# Default path
set ip_repo_path        {$script_folder/../../../../}
set bd_name             {system}
set device              {xc7z007sclg400-1}
set project_name        {example}
set project_dir         {./}

# Help information for this script
proc help {} {
  global script_file
  puts "\nDescription:"
  puts "Create Vivado example project for seven segment display IP targeting"
  puts "Blackboard rev. D."
  puts "Syntax:"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--project_dir <path\]"
  puts "$script_file -tclargs \[--help\]"
  puts "Usage:"
  puts "Name                   Description"
  puts "------------------------------------------------------------------"
  puts "\[--project_name <name>\] Create project with the specified name."
  puts "                       Default name is \"example\"."
  puts "\[--project_dir <path>\]  Determine the project paths wrt to \".\"."
  puts "                       Default project path value is \".\"."
  puts "\[--help\]               Print help information for this script"
  puts "------------------------------------------------------------------\n" 
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < [llength $::argc]} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--project_dir"   { incr i; set project_dir [lindex $::argv $i] }
      "--project_name" { incr i; set project_name [lindex $::argv $i] }
      "--help"         { help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Create project
create_project $project_name $project_dir -part $device
set_property ip_repo_paths ${ip_repo_path} [current_fileset]
update_ip_catalog -rebuild

# Create block design
set current_bd [create_bd_design $bd_name]
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
    global script_folder
    # Add Zynq processing system
    set ps_cell [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7 $cellName ]
    apply_ps_presets $ps_cell $script_folder/BlackBoard_ps_presets.tcl
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

# Save block design
save_bd_design
set bd_filename [get_property FILE_NAME [current_bd_design]]

# Close block design
close_bd_design $current_bd

# Disable OOC
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
set file "[file normalize "$script_folder/system.xdc"]"
set file_imported [import_files -fileset constrs_1 [list $file]]

puts ""
puts "############################################"
puts "# Implementation Starts"
puts "############################################"
puts ""

# Launch implementation and bitstream generation
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

puts ""
puts "############################################"
puts "# Implementation Done"
puts "############################################"
puts ""

# Export locally to SDK
puts ""
puts "############################################"
puts "# Export to SDK locally"
puts "############################################"
puts ""
set sdk_workspace $project_dir/$project_name.sdk
file mkdir $sdk_workspace
set hw_spec_file $sdk_workspace/system_wrapper.hdf
file copy $project_dir/$project_name.runs/impl_1/system_wrapper.sysdef $hw_spec_file

