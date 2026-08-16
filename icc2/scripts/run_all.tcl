###############################################################################
# run_all.tcl
# Complete ICC2 flow for MMA
###############################################################################

set SCRIPT_DIR ../scripts

foreach script_file [list \
    common_setup.tcl \
    floorplan.tcl \
    power_plan.tcl \
    pg_repair.tcl \
    placement.tcl \
    clock.tcl \
    route.tcl \
    fillers.tcl \
    reports.tcl \
] {
    if {![file exists $SCRIPT_DIR/$script_file]} {
        error "Missing required script: $SCRIPT_DIR/$script_file"
    }
}

puts "INFO: Starting complete ICC2 flow for MMA"

source $SCRIPT_DIR/floorplan.tcl
source $SCRIPT_DIR/power_plan.tcl
source $SCRIPT_DIR/placement.tcl
source $SCRIPT_DIR/clock.tcl
source $SCRIPT_DIR/route.tcl
source $SCRIPT_DIR/fillers.tcl
source $SCRIPT_DIR/reports.tcl

puts "INFO: ICC2 flow completed."
puts "INFO: Review reports:"
puts "INFO:   ../reports/summary.txt"
puts "INFO:   ../reports/area.rpt"
puts "INFO:   ../reports/power.rpt"
puts "INFO:   ../reports/qor.rpt"
puts "INFO:   ../reports/timing.rpt"
puts "INFO:   ../reports/constraint.rpt"
puts "INFO:   ../reports/physical.rpt"
puts "INFO:   ../reports/signoff.rpt"
