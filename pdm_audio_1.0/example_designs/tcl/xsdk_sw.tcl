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
# @file xsdk_sw.tcl
#
# XSDK batch mode script for software project generation and compilation. 
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

set project_name        {pdm_audio_proj}
set sdk_workspace       ./$project_name/$project_name.sdk
set hwspec_file         $sdk_workspace/system_wrapper.hdf

set bsp_name       standalone_bsp
set bsp_path       $sdk_workspace/$bsp_name
set mss_file       $bsp_path/system.mss
set app_name       audio_test

proc get_processor {hdf} {
    hsi open_hw_design $hdf
    return [hsi get_cells -filter {IP_TYPE==PROCESSOR}] 
}

set proc_name [get_processor $hwspec_file]

# Set sdk workspace
hsi::utils::init_repo
setws $sdk_workspace

# Create bsp file
sdk createhw -name hw -hwspec $hwspec_file
sdk createbsp -name $bsp_name -proc $proc_name -hwproject hw -os standalone
hsi add_library xilffs
hsi set_property CONFIG.stdin ps7_uart_1 [hsi get_os]
hsi set_property CONFIG.stdout ps7_uart_1 [hsi get_os]
hsi generate_bsp -sw_mss $mss_file -dir $bsp_path
sdk createapp -name zynq_fsbl -proc $proc_name -hwproject hw -bsp $bsp_name -os standalone -app {Zynq FSBL}
sdk createapp -name audio_test -proc $proc_name -hwproject hw -bsp $bsp_name -os standalone -app {Empty Application}
sdk configapp -app audio_test -add libraries {m}

foreach {src_file} [glob "$script_folder/../src/*"] {
	file copy $src_file $sdk_workspace/audio_test/src/
}

sdk build_project
