###############################################################################
# File: system.xdc 
# Author: Tinghui Wang
#
# Copyright (c) 2018-2019, RealDigital.org
#
# Description:
#   I/O constraints file for seven segment display example project targeting
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

set_property -dict { PACKAGE_PIN K19 IOSTANDARD LVCMOS33 } [get_ports { ssd_an[0] }]; #SSEG_AN0
set_property -dict { PACKAGE_PIN H17 IOSTANDARD LVCMOS33 } [get_ports { ssd_an[1] }]; #SSEG_AN1
set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports { ssd_an[2] }]; #SSEG_AN2
set_property -dict { PACKAGE_PIN L16 IOSTANDARD LVCMOS33 } [get_ports { ssd_an[3] }]; #SSEG_AN3
set_property -dict { PACKAGE_PIN K14 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathode[0] }]; #SSEG_CA
set_property -dict { PACKAGE_PIN H15 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathode[1] }]; #SSEG_CB
set_property -dict { PACKAGE_PIN J18 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathode[2] }]; #SSEG_CC
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathode[3] }]; #SSEG_CD
set_property -dict { PACKAGE_PIN M17 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathode[4] }]; #SSEG_CE
set_property -dict { PACKAGE_PIN J16 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathode[5] }]; #SSEG_CF
set_property -dict { PACKAGE_PIN H18 IOSTANDARD LVCMOS33 } [get_ports { ssd_cathode[6] }]; #SSEG_CG
set_property -dict { PACKAGE_PIN K18 IOSTANDARD LVCMOS33 } [get_ports { ssd_dp }]; #SSEG_DP

# Bitstream Compression
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
# Temporary fix for pulldown...
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLUP [current_design]

