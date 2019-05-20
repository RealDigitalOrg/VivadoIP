###############################################################################
# File: create_project.tcl
# Author: Tinghui Wang
#
# Copyright (c) 2018-2019, RealDigital.org
#
# Description:
#   Create example design of HDMI module targeting Blackboard rev. D. 
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
set bd_name             {system}
set device              {xc7z007sclg400-1}
set project_name        {example}
set project_dir         {./}

# Help information for this script
proc help {} {
  global script_file
  puts "\nDescription:"
  puts "Create Vivado example project for HDMI TX IP targeting"
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
 "[file normalize "$script_folder/../../sim/wrapper-syn-revd.v"]"\
]
add_files -norecurse -fileset $src_set $files
set_property -name "top" -value "wrapper" -objects $src_set

# Create constraints set and add files
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}
set con_set [get_filesets constrs_1]
set file "[file normalize "$script_folder/blackboard_revD_video.xdc"]"
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

