###############################################################################
# File: blackboard_revD_video.xdc 
# Author: Tinghui Wang
#
# Copyright (c) 2018-2019, RealDigital.org
#
# Description:
#   I/O constraints file for HDMI example project targeting Blackboard rev. D.
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

# BTN-0
set_property PACKAGE_PIN W14 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

# SYSCLK 100MHz
set_property PACKAGE_PIN H16 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk -waveform {0.000 4.000} -add [get_ports clk]

set_property PACKAGE_PIN M15 [get_ports {sw[7]}]
set_property PACKAGE_PIN L15 [get_ports {sw[6]}]
set_property PACKAGE_PIN P14 [get_ports {sw[5]}]
set_property PACKAGE_PIN R14 [get_ports {sw[4]}]
set_property PACKAGE_PIN N16 [get_ports {sw[3]}]
set_property PACKAGE_PIN R16 [get_ports {sw[2]}]
set_property PACKAGE_PIN U20 [get_ports {sw[1]}]
set_property PACKAGE_PIN R17 [get_ports {sw[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]

set_property PACKAGE_PIN U18 [get_ports {TMDS_CLK_P}]
set_property PACKAGE_PIN U19 [get_ports {TMDS_CLK_N}]

set_property PACKAGE_PIN P19 [get_ports {TMDS_DATA_N[2]}]
set_property PACKAGE_PIN N18 [get_ports {TMDS_DATA_P[2]}]
set_property PACKAGE_PIN P18 [get_ports {TMDS_DATA_N[1]}]
set_property PACKAGE_PIN N17 [get_ports {TMDS_DATA_P[1]}]
set_property PACKAGE_PIN V18 [get_ports {TMDS_DATA_N[0]}]
set_property PACKAGE_PIN V17 [get_ports {TMDS_DATA_P[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS*}]

set_property PACKAGE_PIN P16 [get_ports hdmi_tx_hpd]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_tx_hpd]

# Bitstream Compression
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLUP [current_design]
