###############################################################################
# floorplan.tcl
# ICC2 floorplan for padless MMA block
###############################################################################

source ../scripts/common_setup.tcl

ac_require_dir  $NDM_REF_LIB
ac_require_file $TECH_FILE
ac_require_file $NETLIST_FILE
ac_require_file $SDC_FILE

catch {close_lib}

if {[file exists $ICC2_LIB]} {
    file delete -force $ICC2_LIB
}

create_lib -ref_libs $NDM_REF_LIB -technology $TECH_FILE $ICC2_LIB

read_verilog -as_block $NETLIST_FILE
current_block $DESIGN_NAME
link_block

remove_modes -all
remove_corners -all
remove_scenarios -all

create_mode func
create_corner nom
create_scenario -name func.nom -mode func -corner nom
current_scenario func.nom

source $SDC_FILE

###############################################################################
# Padless block: do not create VDD/VSS top-level ports.
# MMA has many wide bus pins, so 70% utilization is okay but not overly dense.
###############################################################################

initialize_floorplan \
    -core_utilization 0.70 \
    -core_offset {5 5} \
    -coincident_boundary false

set_individual_pin_constraints \
    -ports [get_ports *] \
    -sides {1 2 3 4} \
    -pin_spacing_distance 2

place_pins -self

save_block -as mma_floorplan

puts "INFO: floorplan.tcl completed"
