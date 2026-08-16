###############################################################################
# synth_mma.tcl
# Design Compiler synthesis script for Matrix Multiplication Accelerator
# Tool target: DC W-2024.09-SP1
#
# Reports generated:
#   area.rpt
#   power.rpt
#   constraint.rpt
#   qor.rpt
#   timing.rpt
###############################################################################

set DESIGN_NAME mma
set REPORT_DIR  ../reports
set RESULT_DIR  ../results
set SOURCE_DIR  ../source

file mkdir $REPORT_DIR
file mkdir $RESULT_DIR

proc require_file {path} {
    if {![file exists $path]} {
        error "Required file not found: $path"
    }
}

###############################################################################
# Disable accidental power budget constraints since the default is zero
###############################################################################

proc ac_disable_power_budget_constraints {} {
    puts "INFO: Setting non-limiting power budgets"

    catch {remove_attribute [current_design] max_leakage_power}
    catch {remove_attribute [current_design] max_dynamic_power}
    catch {remove_attribute [current_design] max_total_power}

    catch {set_max_leakage_power 1000000000000000}
    catch {set_max_dynamic_power 1000000000000000}

    catch {set_max_leakage_power 1000000000000000 [current_design]}
    catch {set_max_dynamic_power 1000000000000000 [current_design]}
}

###############################################################################
# Input files
###############################################################################

set RTL_FILES [list \
    $SOURCE_DIR/mma.v \
]

foreach f $RTL_FILES {
    require_file $f
}

require_file $SOURCE_DIR/mma.sdc

###############################################################################
# Read / elaborate / link
###############################################################################

set_app_var hdlin_enable_rtldrc_info true

analyze -format verilog $RTL_FILES
elaborate $DESIGN_NAME

current_design $DESIGN_NAME

link
uniquify

###############################################################################
# Constraints
###############################################################################

source $SOURCE_DIR/mma.sdc

ac_disable_power_budget_constraints

###############################################################################
# Netlist cleanup and hold fixing
###############################################################################

set_fix_multiple_port_nets -all -buffer_constants [get_designs *]

set_fix_hold [get_clocks Clock]

###############################################################################
# Compile
###############################################################################

# MMA is arithmetic-heavy. compile_ultra can infer and optimize arithmetic logic.
compile_ultra -no_autoungroup

ac_disable_power_budget_constraints

set_fix_multiple_port_nets -all -buffer_constants [get_designs *]

compile_ultra -incremental -no_autoungroup

ac_disable_power_budget_constraints

###############################################################################
# Reports
###############################################################################

redirect -tee $REPORT_DIR/area.rpt {
    report_area -hierarchy
}

redirect -tee $REPORT_DIR/power.rpt {
    report_power -hierarchy
}

redirect -tee $REPORT_DIR/constraint.rpt {
    report_constraint -all_violators -verbose
}

redirect -tee $REPORT_DIR/qor.rpt {
    report_qor
}

redirect -tee $REPORT_DIR/timing.rpt {
    report_timing -delay_type max -max_paths 20 -significant_digits 4
}

###############################################################################
# Outputs for ICC2
###############################################################################

write -hierarchy -format verilog -output $RESULT_DIR/mma_compiled.v
write -hierarchy -format ddc     -output $RESULT_DIR/mma_compiled.ddc
write_sdc $RESULT_DIR/mma_out.sdc

###############################################################################
# Strip unwanted power-budget commands from output SDC
###############################################################################

set clean_sdc $RESULT_DIR/mma_out.sdc

if {[file exists $clean_sdc]} {
    set fp_in [open $clean_sdc r]
    set sdc_text [read $fp_in]
    close $fp_in

    set fp_out [open $clean_sdc w]

    foreach line [split $sdc_text "\n"] {
        if {[regexp -nocase {set_max_leakage_power|set_max_dynamic_power|set_max_total_power} $line]} {
            puts "INFO: Removing power-budget line from output SDC: $line"
        } else {
            puts $fp_out $line
        }
    }

    close $fp_out
}

file copy -force $RESULT_DIR/mma_compiled.v ../../icc2/source/mma_compiled.v
file copy -force $RESULT_DIR/mma_out.sdc    ../../icc2/source/mma_out.sdc

puts "INFO: DC synthesis completed."
puts "INFO: Generated reports:"
puts "INFO:   ../reports/area.rpt"
puts "INFO:   ../reports/power.rpt"
puts "INFO:   ../reports/constraint.rpt"
puts "INFO:   ../reports/qor.rpt"
puts "INFO:   ../reports/timing.rpt"

exit
