###############################################################################
# mma.sdc
# SDC for Matrix Multiplication Accelerator
# Design: mma
# Library/corner: SAED32 RVT TT 0.85 V 25 C
###############################################################################

set_units -time ns -capacitance fF -voltage V -current uA

###############################################################################
# Clock
###############################################################################

set CLK_PERIOD_NS 10.000
set CLK_NAME      Clock

create_clock \
    -name $CLK_NAME \
    -period $CLK_PERIOD_NS \
    -waveform [list 0 [expr {$CLK_PERIOD_NS / 2.0}]] \
    [get_ports Clock]

###############################################################################
# Clock uncertainty
###############################################################################

set_clock_uncertainty -setup 0.200 [get_clocks $CLK_NAME]
set_clock_uncertainty -hold  0.020 [get_clocks $CLK_NAME]

###############################################################################
# I/O delay assumptions
###############################################################################

set INPUT_DELAY_MAX_NS  2.000
set INPUT_DELAY_MIN_NS  0.000
set OUTPUT_DELAY_MAX_NS 2.000
set OUTPUT_DELAY_MIN_NS 0.000

set DATA_INPUTS [remove_from_collection [all_inputs] [get_ports {Clock Reset}]]

set_input_delay  -max $INPUT_DELAY_MAX_NS  -clock [get_clocks $CLK_NAME] $DATA_INPUTS
set_input_delay  -min $INPUT_DELAY_MIN_NS  -clock [get_clocks $CLK_NAME] $DATA_INPUTS

set_output_delay -max $OUTPUT_DELAY_MAX_NS -clock [get_clocks $CLK_NAME] [all_outputs]
set_output_delay -min $OUTPUT_DELAY_MIN_NS -clock [get_clocks $CLK_NAME] [all_outputs]

###############################################################################
# Electrical assumptions
###############################################################################

set_input_transition 0.200 $DATA_INPUTS
set_load 0.050 [all_outputs]

###############################################################################
# Reset
###############################################################################

# Reset is synchronous in this RTL because it is checked inside always @(posedge Clock).
# Therefore do not set Reset as asynchronous false path.
# Reset is treated as a normal synchronous input with input delay.
###############################################################################

check_timing
