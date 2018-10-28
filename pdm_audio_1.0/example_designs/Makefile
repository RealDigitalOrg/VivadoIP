# Blackboard revD

all: blackboard

blackboard:
	vivado -mode batch -source tcl/project.tcl tcl/compile.tcl
	xsdk -batch -source tcl/xsdk_sw.tcl

clean:
	rm -fv *.log
	rm -fv *.jou
	rm -fv *.str
	rm -rf pdm_audio_proj
	rm -rf .Xil

