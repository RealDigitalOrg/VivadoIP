# Blackboard revD

all: blackboard

blackboard:
	vivado -source tcl/project.tcl

clean:
	rm -rfv *.log
	rm -rfv *.jou
	rm -rfv hdmi_test
	rm -fv $(filter-out $(wildcard ../sim/clk_wiz_0/*.xci),$(wildcard ../sim/clk_wiz_0/*))
	rm -rfv .Xil

