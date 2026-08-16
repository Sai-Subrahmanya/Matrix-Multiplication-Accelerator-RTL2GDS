###############################################################################
# reports.tcl
# Tool target: IC Compiler II W-2024.09-SP1
#
# Reports generated:
#   summary.txt
#   area.rpt
#   power.rpt
#   qor.rpt
#   timing.rpt
#   constraint.rpt
#   physical.rpt
#   signoff.rpt
###############################################################################

source ../scripts/common_setup.tcl

file mkdir $REPORT_DIR

###############################################################################
# 1. Area / utilization
###############################################################################

ac_redirect $REPORT_DIR/area.rpt {
    report_utilization
}

###############################################################################
# 2. Power
###############################################################################

ac_redirect $REPORT_DIR/power.rpt {
    report_power
}

###############################################################################
# 3. QoR
###############################################################################

ac_redirect $REPORT_DIR/qor.rpt {
    report_qor
}

###############################################################################
# 4. Timing
###############################################################################

ac_redirect $REPORT_DIR/timing.rpt {
    report_timing -delay_type max -max_paths 10 -significant_digits 4
    report_timing -delay_type min -max_paths 10 -significant_digits 4
}

###############################################################################
# 5. Constraint
###############################################################################

ac_redirect $REPORT_DIR/constraint.rpt {
    report_constraint -all_violators -verbose
}

###############################################################################
# 6. Physical summary
###############################################################################

ac_redirect $REPORT_DIR/physical.rpt {
    report_congestion
    report_clock_qor
}

###############################################################################
# 7. Signoff
#
# Final pass/fail:
#   check_routes
#   check_pg_connectivity
#   focused filtered check_pg_missing_vias
#   check_pg_drc
###############################################################################

set pg_nets [get_nets {VDD VSS}]

redirect -tee $REPORT_DIR/signoff.rpt "
    check_routes

    check_pg_connectivity

    check_pg_missing_vias \
        -nets \$pg_nets \
        -shape_use {lib_cell_pin_connect follow_pin} \
        -ignore_small_intersections \
        -filter_by_drc

    check_pg_drc
"

###############################################################################
# 8. Summary
###############################################################################

set summary_file $REPORT_DIR/summary.txt
set fp [open $summary_file w]

puts $fp "MMA ICC2 final compact summary"
puts $fp "Generated at: [clock format [clock seconds]]"
puts $fp ""
puts $fp "Generated reports:"
puts $fp "  area.rpt"
puts $fp "  power.rpt"
puts $fp "  qor.rpt"
puts $fp "  timing.rpt"
puts $fp "  constraint.rpt"
puts $fp "  physical.rpt"
puts $fp "  signoff.rpt"
puts $fp ""

close $fp

catch {
    exec sh -c "echo '--- Area/utilization key lines ---' >> $summary_file; grep -Ei 'Utilization|Total Area|Total Capacity|Total Area of cells|Ratio' $REPORT_DIR/area.rpt >> $summary_file || true"
}

catch {
    exec sh -c "echo '\n--- Power key lines ---' >> $summary_file; grep -Ei 'Total Dynamic Power|Cell Leakage Power|Total ' $REPORT_DIR/power.rpt >> $summary_file || true"
}

catch {
    exec sh -c "echo '\n--- QoR key lines ---' >> $summary_file; grep -Ei 'WNS|TNS|violat|slack|Critical Path|Max Trans|Max Cap|Nets with Violations' $REPORT_DIR/qor.rpt >> $summary_file || true"
}

catch {
    exec sh -c "echo '\n--- Constraint key lines ---' >> $summary_file; grep -Ei 'VIOLATED|max_cap|max_transition|Total number of violation' $REPORT_DIR/constraint.rpt >> $summary_file || true"
}

catch {
    exec sh -c "echo '\n--- Signoff key lines ---' >> $summary_file; grep -Ei 'short violations|open nets|floating|missing vias|Total number of errors|Total number of DRCs|No errors found|TOTAL VIOLATIONS' $REPORT_DIR/signoff.rpt >> $summary_file || true"
}

puts "INFO: reports.tcl completed"
