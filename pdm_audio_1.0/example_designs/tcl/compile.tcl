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
# @file compile.tcl
#
# Vivado tcl script to compile and export project 
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
set sdk_workspace $project_name/$project_name.sdk
file mkdir $sdk_workspace
set hw_spec_file $sdk_workspace/system_wrapper.hdf
file copy $project_name/$project_name.runs/impl_1/system_wrapper.sysdef $hw_spec_file

