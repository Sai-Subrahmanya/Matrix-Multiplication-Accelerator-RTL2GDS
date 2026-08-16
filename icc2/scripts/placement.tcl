###############################################################################
# placement.tcl
# ICC2 placement for MMA
###############################################################################

source ../scripts/common_setup.tcl

ac_require_file $TLUPLUS_MAX
ac_require_file $TLUPLUS_MIN
ac_require_file $TLUPLUS_MAP

read_parasitic_tech \
    -tlup $TLUPLUS_MAX \
    -layermap $TLUPLUS_MAP \
    -name tlu_max

read_parasitic_tech \
    -tlup $TLUPLUS_MIN \
    -layermap $TLUPLUS_MAP \
    -name tlu_min

set_parasitic_parameters \
    -corner nom \
    -early_spec tlu_min \
    -late_spec tlu_max

set_ignored_layers \
    -min_routing_layer M2 \
    -max_routing_layer M8

###############################################################################
# MMA is arithmetic-heavy, but DC has already mapped arithmetic.
# Avoid large arithmetic macro cells only if they appear in ref lib.
###############################################################################

set fadd_cells [get_lib_cells -quiet */FADD*]
if {[sizeof_collection $fadd_cells] > 0} {
    set_dont_use $fadd_cells
}

set hadd_cells [get_lib_cells -quiet */HADD*]
if {[sizeof_collection $hadd_cells] > 0} {
    set_dont_use $hadd_cells
}

place_opt

ac_connect_pg

save_block -as mma_placement

puts "INFO: placement.tcl completed"
