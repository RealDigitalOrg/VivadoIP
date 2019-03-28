###############################################################################
# File: system.xdc 
# Author: Tinghui Wang
#
# Copyright (c) 2018-2019, RealDigital.org
#
# Description:
#   I/O constraints file for AXI PWM IP Core example project targeting
#   BlackBoard rev. D.
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

# RGB LEDs
set_property -dict { PACKAGE_PIN Y14 IOSTANDARD LVCMOS33 } [get_ports { rgb_pwm[5] }]; #LD11_R
set_property -dict { PACKAGE_PIN Y16 IOSTANDARD LVCMOS33 } [get_ports { rgb_pwm[4] }]; #LD11_G
set_property -dict { PACKAGE_PIN Y17 IOSTANDARD LVCMOS33 } [get_ports { rgb_pwm[3] }]; #LD11_B
set_property -dict { PACKAGE_PIN W18 IOSTANDARD LVCMOS33 } [get_ports { rgb_pwm[2] }]; #LD10_R
set_property -dict { PACKAGE_PIN W16 IOSTANDARD LVCMOS33 } [get_ports { rgb_pwm[1] }]; #LD10_G
set_property -dict { PACKAGE_PIN Y18 IOSTANDARD LVCMOS33 } [get_ports { rgb_pwm[0] }]; #LD10_B

# Bitstream Compression
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
# Temporary fix for pulldown...
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLUP [current_design]

