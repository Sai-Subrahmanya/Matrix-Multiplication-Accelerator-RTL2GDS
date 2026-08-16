###############################################################################
# power_plan.tcl
# PG creation for padless MMA standard-cell block
###############################################################################

source ../scripts/common_setup.tcl

ac_create_pg_nets
ac_connect_pg

###############################################################################
# Core ring
###############################################################################

create_pg_ring_pattern core_ring_pattern \
    -horizontal_layer M7 \
    -horizontal_width 0.70 \
    -horizontal_spacing 0.40 \
    -vertical_layer M8 \
    -vertical_width 0.70 \
    -vertical_spacing 0.40

set_pg_strategy core_power_ring \
    -core \
    -pattern {{name: core_ring_pattern} {nets: {VDD VSS}} {offset: {1.0 1.0}}}

compile_pg -strategies core_power_ring

###############################################################################
# Upper PG mesh
###############################################################################

create_pg_mesh_pattern core_mesh_pattern \
    -layers { \
        {{vertical_layer: M6}   {width: 0.34} {spacing: interleaving} {pitch: 20} {offset: 2.0}} \
        {{horizontal_layer: M7} {width: 0.38} {spacing: interleaving} {pitch: 20} {offset: 2.0}} \
    }

set_pg_strategy core_mesh \
    -core \
    -pattern {{name: core_mesh_pattern} {nets: {VDD VSS}}} \
    -extension {{stop: innermost_ring}}

compile_pg -strategies core_mesh

###############################################################################
# Standard-cell rails
###############################################################################

create_pg_std_cell_conn_pattern std_cell_rail \
    -layers M1 \
    -rail_width 0.01

set_pg_strategy rail_strategy \
    -core \
    -pattern {{name: std_cell_rail} {nets: {VDD VSS}}}

compile_pg -strategies rail_strategy

###############################################################################
# Low-layer PG stitch repair
###############################################################################

source ../scripts/pg_repair.tcl

ac_connect_pg

save_block -as mma_powerplan

puts "INFO: power_plan.tcl completed"
