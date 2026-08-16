###############################################################################
# pg_repair.tcl
# Fine low-layer PG stitch repair for VDD/VSS
#
# This is the stable padless-block PG repair strategy.
# It avoids forcing raw missing vias because forced vias created M2 min-area DRC.
###############################################################################

source ../scripts/common_setup.tcl

puts "INFO: Starting fine low-layer PG stitch repair"

ac_create_pg_nets
ac_connect_pg

catch {remove_pg_strategies pg_stitch_strategy}
catch {remove_pg_patterns pg_stitch_pattern}

create_pg_mesh_pattern pg_stitch_pattern \
    -layers { \
        {{vertical_layer: M2}   {width: 0.12} {spacing: interleaving} {pitch: 6.0} {offset: 1.0}} \
        {{horizontal_layer: M3} {width: 0.12} {spacing: interleaving} {pitch: 6.0} {offset: 1.0}} \
    }

set_pg_strategy pg_stitch_strategy \
    -core \
    -pattern {{name: pg_stitch_pattern} {nets: {VDD VSS}}} \
    -extension {{stop: innermost_ring}}

compile_pg -strategies pg_stitch_strategy

ac_connect_pg

save_block -as mma_pg_repaired

puts "INFO: pg_repair.tcl completed"
