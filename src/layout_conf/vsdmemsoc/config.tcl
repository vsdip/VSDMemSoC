# Base Configurations. Don't Touch
# section begin

set ::env(PDK) "sky130A"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

set script_dir [file dirname [file normalize [info script]]]

# YOU ARE NOT ALLOWED TO CHANGE ANY VARIABLES DEFINED IN THE FIXED WRAPPER CFGS 
source $script_dir/fixed_wrapper_cfgs.tcl

# YOU CAN CHANGE ANY VARIABLES DEFINED IN THE DEFAULT WRAPPER CFGS BY OVERRIDING THEM IN THIS CONFIG.TCL
source $script_dir/default_wrapper_cfgs.tcl

set ::env(DESIGN_NAME) vsdmemsoc
#section end

# User Configurations

## Source Verilog Files
set ::env(VERILOG_FILES) "\
    $script_dir/src/module/*.v"

## Clock configurations
set ::env(CLOCK_PORT) "CLK"
set ::env(CLOCK_NET) "CLK"

set ::env(CLOCK_PERIOD) "50"

## Internal Macros
### Macro PDN Connections
set ::env(FP_PDN_MACRO_HOOKS) "\
	cntlr vccd1 vssd1"

### Macro Placement
set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg

### Black-box verilog and views
set ::env(VERILOG_FILES_BLACKBOX) "\
    $script_dir/src/blackbox/controller.v \
	$script_dir/src/blackbox/sram_32_256_sky130A.v"

set ::env(EXTRA_LEFS) "\
	$script_dir/src/lef/controller.lef \
    $script_dir/src/lef/sram_32_256_sky130A.lef"

set ::env(EXTRA_GDS_FILES) "\
	$script_dir/src/gds/controller.gds \
    $script_dir/src/gds/sram_32_256_sky130A.gds"

set ::env(GLB_RT_MAXLAYER) 5

# disable pdn check nodes becuase it hangs with multiple power domains.
# any issue with pdn connections will be flagged with LVS so it is not a critical check.
set ::env(FP_PDN_CHECK_NODES) 0

# The following is because there are no std cells in the example wrapper project.
set ::env(SYNTH_TOP_LEVEL) 1
set ::env(PL_RANDOM_GLB_PLACEMENT) 1

set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) 0
set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) 0

set ::env(FP_PDN_ENABLE_RAILS) 0

set ::env(DIODE_INSERTION_STRATEGY) 0
set ::env(FILL_INSERTION) 0
set ::env(TAP_DECAP_INSERTION) 0
set ::env(CLOCK_TREE_SYNTH) 0
