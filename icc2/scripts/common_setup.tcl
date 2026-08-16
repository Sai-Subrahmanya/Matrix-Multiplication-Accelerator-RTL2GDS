###############################################################################
# common_setup.tcl
# Common ICC2 setup for MMA
# Tool target: IC Compiler II W-2024.09-SP1
###############################################################################

set DESIGN_NAME  mma
set PROJECT_ROOT [file normalize ../..]
set PDK_PATH     $PROJECT_ROOT/ref

set SOURCE_DIR   ../source
set REPORT_DIR   ../reports
set RESULT_DIR   ../results
set ICC2_LIB     mma_lib

set NDM_REF_LIB  $PDK_PATH/lib/ndm/saed32_rvt.ndm
set TECH_FILE    $PDK_PATH/tech/milkyway/saed32nm_1p9m_mw.tf

set TLUPLUS_MAX  $PDK_PATH/tech/star_rcxt/saed32nm_1p9m_Cmax.tluplus
set TLUPLUS_MIN  $PDK_PATH/tech/star_rcxt/saed32nm_1p9m_Cmin.tluplus
set TLUPLUS_MAP  $PDK_PATH/tech/star_rcxt/saed32nm_tf_itf_tluplus.map

set GDS_MAP      $PDK_PATH/tech/saed32nm_1p9m_gdsout_mw.map
set MERGE_GDS    $PDK_PATH/tech/saed32nm_rvt_oa.gds

set NETLIST_FILE $SOURCE_DIR/mma_compiled.v
set SDC_FILE     $SOURCE_DIR/mma_out.sdc

file mkdir $REPORT_DIR
file mkdir $RESULT_DIR

proc ac_require_file {file_name} {
    if {![file exists $file_name]} {
        error "Required file not found: $file_name"
    }
}

proc ac_require_dir {dir_name} {
    if {![file isdirectory $dir_name]} {
        error "Required directory not found: $dir_name"
    }
}

proc ac_safe {cmd_body} {
    if {[catch {uplevel 1 $cmd_body} msg]} {
        puts "WARNING: Optional command failed: $msg"
        return 0
    }
    return 1
}

proc ac_redirect {outfile cmd_body} {
    if {[catch {redirect -tee $outfile $cmd_body} msg]} {
        puts "WARNING: Report command failed for $outfile"
        puts "WARNING: $msg"
        return 0
    }
    return 1
}

proc ac_set_app_option {name value} {
    if {[catch {set_app_options -name $name -value $value} msg]} {
        puts "WARNING: set_app_options $name failed/skipped: $msg"
        return 0
    }
    return 1
}

proc ac_create_pg_nets {} {
    if {[sizeof_collection [get_nets -quiet VDD]] == 0} {
        create_net -power VDD
    }

    if {[sizeof_collection [get_nets -quiet VSS]] == 0} {
        create_net -ground VSS
    }

    catch {set_attribute [get_nets VDD] net_type power}
    catch {set_attribute [get_nets VSS] net_type ground}
}

proc ac_connect_pg {} {
    ac_create_pg_nets

    set vdd_pins [get_pins -hierarchical -quiet */VDD]
    if {[sizeof_collection $vdd_pins] > 0} {
        catch {connect_pg_net -net VDD $vdd_pins}
    }

    set vss_pins [get_pins -hierarchical -quiet */VSS]
    if {[sizeof_collection $vss_pins] > 0} {
        catch {connect_pg_net -net VSS $vss_pins}
    }

    catch {connect_pg_net -automatic}
}
