###############################################################################
# clock.tcl
# CTS for MMA
###############################################################################

source ../scripts/common_setup.tcl

###############################################################################
# Primary SDC clock is Clock
###############################################################################

set_clock_routing_rules \
    -min_routing_layer M3 \
    -max_routing_layer M4 \
    -default_rule

synthesize_clock_tree

ac_set_app_option clock_opt.flow.enable_ccd true

clock_opt -from build_clock -to route_clock

ac_connect_pg

save_block -as mma_cts

puts "INFO: clock.tcl completed"
