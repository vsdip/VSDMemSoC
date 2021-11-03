set ::env(PDK) "sky130A"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) controller

set ::env(VERILOG_FILES) "\
	$script_dir/src/module/controller.v \
	$script_dir/src/module/clk_gate.v \
	$script_dir/src/module/rvmyth.v"

set ::env(VERILOG_INCLUDE_DIRS) "\
	$script_dir/src/include"

set ::env(DESIGN_IS_CORE) 0

set ::env(CLOCK_PORT) "CLK"
set ::env(CLOCK_NET) "CLK"
set ::env(CLOCK_PERIOD) "50"

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 1500 1500"

set ::env(PL_TARGET_DENSITY) 0.2

set ::env(VDD_NETS) [list {vccd1}]
set ::env(GND_NETS) [list {vssd1}]

set ::env(PL_RESIZER_HOLD_SLACK_MARGIN) 0.8
set ::env(GLB_RESIZER_HOLD_SLACK_MARGIN) 0.8
set ::env(GLB_RT_MAXLAYER) 5

set ::env(DIODE_INSERTION_STRATEGY) 4

set ::env(RUN_CVC) 1