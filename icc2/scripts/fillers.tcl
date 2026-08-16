###############################################################################
# fillers.tcl
# Filler insertion and output generation for MMA
###############################################################################

source ../scripts/common_setup.tcl

ac_require_file $GDS_MAP
ac_require_file $MERGE_GDS

catch {remove_stdcell_fillers_with_violation}

legalize_placement -incremental

set filler_cells [get_lib_cells -quiet */SHFILL*]

if {[sizeof_collection $filler_cells] == 0} {
    set filler_cells [get_lib_cells -quiet */FILL*]
}

if {[sizeof_collection $filler_cells] == 0} {
    error "No filler cells found. Check SAED32 RVT filler cell names."
}

create_stdcell_fillers -lib_cells $filler_cells

legalize_placement -incremental

ac_connect_pg

route_opt

ac_connect_pg

save_block -as mma_final

write_verilog $RESULT_DIR/mma_icc2.v

write_sdc -output $RESULT_DIR/mma_icc2.sdc

write_parasitics \
    -output $RESULT_DIR/mma_icc2.spef \
    -format spef

write_gds \
    -design mma_final \
    -layer_map $GDS_MAP \
    -hierarchy all \
    -keep_data_type \
    -allow_design_mismatch \
    -lib_cell_view frame \
    -units 2000 \
    -output_pin all \
    -merge_files $MERGE_GDS \
    -merge_gds_top_cell $DESIGN_NAME \
    $RESULT_DIR/mma_final.gds

puts "INFO: fillers.tcl completed"
