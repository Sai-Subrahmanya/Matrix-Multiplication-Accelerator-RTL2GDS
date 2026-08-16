###############################################################################
# route.tcl
# Routing for MMA
###############################################################################

source ../scripts/common_setup.tcl

ac_set_app_option route.global.timing_driven true
ac_set_app_option route.detail.antenna true

set antenna_cells [get_lib_cells -quiet */ANTENNA_RVT]

if {[sizeof_collection $antenna_cells] > 0} {
    ac_set_app_option route.detail.diode_libcell_names [get_object_name $antenna_cells]
}

route_global
route_track
route_detail

ac_set_app_option route_opt.flow.enable_ccd true

route_opt
route_opt

ac_connect_pg

save_block -as mma_route

puts "INFO: route.tcl completed"
