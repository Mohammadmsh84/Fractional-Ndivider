################################################################################
# Cadence Genus synthesis for the final Fractional-N Divider RTL.
# Verified server assumptions inherited from Group-4 handoff:
#   library path : /home/cad/TECH.D/TSMC180/lib
#   library      : typical.lib
#   technology   : TSMC 180 nm, typical
#
# Run from any directory:
#   genus -f scripts/synth_genus.tcl | tee sim/gate/genus_console.log
################################################################################

set SCRIPT_DIR [file dirname [file normalize [info script]]]
set ROOT_DIR   [file normalize [file join $SCRIPT_DIR ..]]
cd $ROOT_DIR

set TOP       fractional_n_divider
set RTL_FILE  [file join $ROOT_DIR rtl ${TOP}.v]
set SDC_FILE  [file join $ROOT_DIR constraints fractional_n_divider.sdc]
set OUT_DIR   [file join $ROOT_DIR netlist]
set REP_DIR   [file join $ROOT_DIR sim gate]

file mkdir $OUT_DIR
file mkdir $REP_DIR

puts "------------------------------------------------------------"
puts "Loading TSMC180 typical library"
puts "------------------------------------------------------------"
set_db init_lib_search_path {/home/cad/TECH.D/TSMC180/lib}
set_db library {typical.lib}
set_db script_search_path [list $SCRIPT_DIR]

set_db auto_ungroup none
set_db write_vlog_top_module_first true
set_db remove_assigns true
set_db information_level 1
# latch_out1 and latch_out2 are intentional clock-mux latches.
# Do not enable hdl_error_on_latch for this design.

puts "------------------------------------------------------------"
puts "Reading and elaborating $RTL_FILE"
puts "------------------------------------------------------------"
read_hdl -language sv $RTL_FILE
elaborate
set_top_module $TOP

check_design -unresolved > [file join $REP_DIR ${TOP}_check_design.rpt]

puts "------------------------------------------------------------"
puts "Applying constraints from $SDC_FILE"
puts "------------------------------------------------------------"
source $SDC_FILE
init_design
report_clocks > [file join $REP_DIR ${TOP}_clocks.rpt]

puts "------------------------------------------------------------"
puts "Running synthesis"
puts "------------------------------------------------------------"
syn_generic
syn_map
syn_opt

puts "------------------------------------------------------------"
puts "Writing reports"
puts "------------------------------------------------------------"
report_area                    > [file join $REP_DIR ${TOP}_area.rpt]
report_gates                   > [file join $REP_DIR ${TOP}_gates.rpt]
report_timing -max_paths 10    > [file join $REP_DIR ${TOP}_timing.rpt]
report_power                   > [file join $REP_DIR ${TOP}_power.rpt]
report_clocks                  > [file join $REP_DIR ${TOP}_clocks_final.rpt]

puts "------------------------------------------------------------"
puts "Writing netlist and SDF"
puts "------------------------------------------------------------"
write_hdl > [file join $OUT_DIR ${TOP}_postsyn.v]
write_sdf -version 3.0 -timescale ps -nonegcheck \
          -setuphold split \
          -recrem split \
          > [file join $OUT_DIR ${TOP}_postsyn.sdf]
write_script > [file join $OUT_DIR ${TOP}_constraints.g]

puts "GENUS_SYNTHESIS_COMPLETE"
puts "Netlist: [file join $OUT_DIR ${TOP}_postsyn.v]"
puts "SDF:     [file join $OUT_DIR ${TOP}_postsyn.sdf]"
quit
