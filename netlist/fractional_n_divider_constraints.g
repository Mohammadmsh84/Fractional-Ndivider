######################################################################

# Created by Genus(TM) Synthesis Solution 21.10-p002_1 on Thu Aug 06 16:04:27 +0330 2026

# This file contains the Genus script for design:fractional_n_divider

######################################################################

set_db -quiet init_lib_search_path /home/cad/TECH.D/TSMC180/lib
set_db -quiet design_mode_process no_value
set_db -quiet phys_assume_met_fill 0.0
set_db -quiet map_placed_for_route_early_global false
set_db -quiet phys_use_invs_extraction true
set_db -quiet phys_route_time_out 120.0
set_db -quiet capacitance_per_unit_length_mmmc {}
set_db -quiet resistance_per_unit_length_mmmc {}
set_db -quiet runtime_by_stage {{PBS_Generic-Start 0 14 0.0 18.0} {to_generic 1 15 1 19} {first_condense 0 15 0 19} {PBS_Generic_Opt-Post 1 15 0.9713269999999987 18.971327} {{PBS_Generic-Postgen HBO Optimizations} 0 15 1.0 19.971327} {PBS_TechMap-Start 0 16 0.0 19.971327} {{PBS_TechMap-Premap HBO Optimizations} 0 16 0.0 19.971327} {second_condense 0 16 0 20} {reify 0 16 0 20} {global_incr_map 0 16 0 20} {{PBS_Techmap-Global Mapping} 0 16 -0.07132000000000005 19.900007} {{PBS_TechMap-Datapath Postmap Operations} 1 17 1.0 20.900007} {{PBS_TechMap-Postmap HBO Optimizations} 0 17 -0.0002769999999969741 20.89973} {{PBS_TechMap-Postmap Clock Gating} 0 17 0.0 20.89973} {{PBS_TechMap-Postmap Cleanup} 1 18 -0.00023499999999998522 20.899495} {PBS_Techmap-Post_MBCI 0 18 0.0 20.899495} {incr_opt 0 18 0 22} }
set_db -quiet timing_adjust_tns_of_complex_flops false
set_db -quiet tinfo_tstamp_file .rs_grp2_dsd.tstamp
set_db -quiet metric_enable true
set_db -quiet script_search_path /home/grp2_dsd/workspace/week4_final_g4_integrated/scripts
set_db -quiet auto_ungroup none
set_db -quiet write_vlog_top_module_first true
set_db -quiet remove_assigns true
set_db -quiet flow_metrics_snapshot_uuid 4e5fb459-61aa-4ecd-bb04-42600fa1f260
set_db -quiet read_qrc_tech_file_rc_corner true
set_db -quiet phys_use_segment_parasitics true
set_db -quiet probabilistic_extraction true
set_db -quiet ple_correlation_factors {1.9000 2.0000}
set_db -quiet maximum_interval_of_vias inf
set_db -quiet layer_aware_buffer true
set_db -quiet interconnect_mode wireload
set_db -quiet wireload_mode enclosed
set_db -quiet wireload_selection none
set_db -quiet operating_condition:default_emulate_libset_max/typical/typical .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/typical/_nominal_ .tree_type balanced_tree
# BEGIN MSV SECTION
# END MSV SECTION
define_clock -name clk -domain domain_1 -period 7629390.0 -divide_period 1 -rise 0 -divide_rise 1 -fall 1 -divide_fall 2 -remove -design design:fractional_n_divider port:fractional_n_divider/clk
define_cost_group -design design:fractional_n_divider -name clk
external_delay -accumulate -input {0.0 no_value 0.0 no_value} -clock clock:fractional_n_divider/clk -name create_clock_delay_domain_1_clk_R_0 port:fractional_n_divider/clk
set_db -quiet external_delay:fractional_n_divider/create_clock_delay_domain_1_clk_R_0 .clock_network_latency_included true
external_delay -accumulate -input {no_value 0.0 no_value 0.0} -clock clock:fractional_n_divider/clk -edge_fall -name create_clock_delay_domain_1_clk_F_0 port:fractional_n_divider/clk
set_db -quiet external_delay:fractional_n_divider/create_clock_delay_domain_1_clk_F_0 .clock_network_latency_included true
external_delay -accumulate -input {no_value no_value 100000.0 100000.0} -clock clock:fractional_n_divider/clk -name in_del {{port:fractional_n_divider/N_sel[1]}}
external_delay -accumulate -input {no_value no_value 100000.0 100000.0} -clock clock:fractional_n_divider/clk -name in_del_1_1 {{port:fractional_n_divider/N_sel[0]}}
external_delay -accumulate -input {0.0 0.0 no_value no_value} -clock clock:fractional_n_divider/clk -name in_del_2_1 {{port:fractional_n_divider/N_sel[1]}}
external_delay -accumulate -input {0.0 0.0 no_value no_value} -clock clock:fractional_n_divider/clk -name in_del_3_1 {{port:fractional_n_divider/N_sel[0]}}
external_delay -accumulate -output {no_value no_value 100000.0 100000.0} -clock clock:fractional_n_divider/clk -name ou_del port:fractional_n_divider/INT65K_CLK
external_delay -accumulate -output {0.0 0.0 no_value no_value} -clock clock:fractional_n_divider/clk -name ou_del_3_1 port:fractional_n_divider/INT65K_CLK
path_group -paths [specify_paths -to clock:fractional_n_divider/clk]  -name clk -group cost_group:fractional_n_divider/clk -user_priority -1047552
path_disable -paths [specify_paths -lenient -from port:fractional_n_divider/rst_n]  -name dis_1 -user_priority -770048
# BEGIN DFT SECTION
set_db -quiet dft_scan_style muxed_scan
set_db -quiet dft_scanbit_waveform_analysis false
# END DFT SECTION
set_db -quiet design:fractional_n_divider .seq_reason_deleted_internal {}
set_db -quiet design:fractional_n_divider .qos_by_stage {{to_generic {wns -11111111} {tns -111111111} {vep -111111111} {area 1129} {cell_count 34} {utilization  0.00} {runtime 1 15 1 19} }{first_condense {wns -11111111} {tns -111111111} {vep -111111111} {area 873} {cell_count 25} {utilization  0.00} {runtime 0 15 0 19} }{second_condense {wns -11111111} {tns -111111111} {vep -111111111} {area 873} {cell_count 25} {utilization  0.00} {runtime 0 16 0 20} }{reify {wns 3714094} {tns 0} {vep 0} {area 605} {cell_count 17} {utilization  0.00} {runtime 0 16 0 20} }{global_incr_map {wns 3714094} {tns 0} {vep 0} {area 605} {cell_count 17} {utilization  0.00} {runtime 0 16 0 20} }{incr_opt {wns 214748365} {tns 0} {vep 0} {area 602} {cell_count 16} {utilization  0.00} {runtime 0 18 0 22} }}
set_db -quiet design:fractional_n_divider .is_sop_cluster true
set_db -quiet design:fractional_n_divider .seq_mbci_coverage 0.0
set_db -quiet design:fractional_n_divider .hdl_filelist {{default -sv {SYNTHESIS} {/home/grp2_dsd/workspace/week4_final_g4_integrated/rtl/fractional_n_divider.v} {} {}}}
set_db -quiet design:fractional_n_divider .hdl_user_name fractional_n_divider
set_db -quiet design:fractional_n_divider .verification_directory fv/fractional_n_divider
set_db -quiet design:fractional_n_divider .lp_clock_gating_max_flops inf
set_db -quiet port:fractional_n_divider/clk .original_name clk
set_db -quiet port:fractional_n_divider/rst_n .original_name rst_n
set_db -quiet {port:fractional_n_divider/N_sel[1]} .original_name {N_sel[1]}
set_db -quiet {port:fractional_n_divider/N_sel[0]} .original_name {N_sel[0]}
set_db -quiet port:fractional_n_divider/INT65K_CLK .original_name INT65K_CLK
set_db -quiet inst:fractional_n_divider/q_neg_reg .original_name q_neg
set_db -quiet inst:fractional_n_divider/q_neg_reg .orig_hdl_instantiated false
set_db -quiet inst:fractional_n_divider/q_neg_reg .single_bit_orig_name q_neg
set_db -quiet inst:fractional_n_divider/q_neg_reg .gint_phase_inversion false
set_db -quiet pin:fractional_n_divider/q_neg_reg/Q .original_name q_neg/q
set_db -quiet pin:fractional_n_divider/q_neg_reg/QN .original_name q_neg/q
set_db -quiet inst:fractional_n_divider/q_pos_reg .original_name q_pos
set_db -quiet inst:fractional_n_divider/q_pos_reg .orig_hdl_instantiated false
set_db -quiet inst:fractional_n_divider/q_pos_reg .single_bit_orig_name q_pos
set_db -quiet inst:fractional_n_divider/q_pos_reg .gint_phase_inversion false
set_db -quiet pin:fractional_n_divider/q_pos_reg/Q .original_name q_pos/q
set_db -quiet {inst:fractional_n_divider/counter_reg[1]} .original_name {{counter[1]}}
set_db -quiet {inst:fractional_n_divider/counter_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:fractional_n_divider/counter_reg[1]} .single_bit_orig_name {counter[1]}
set_db -quiet {inst:fractional_n_divider/counter_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:fractional_n_divider/counter_reg[1]/Q} .original_name {counter[1]/q}
set_db -quiet {inst:fractional_n_divider/counter_reg[0]} .original_name {{counter[0]}}
set_db -quiet {inst:fractional_n_divider/counter_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:fractional_n_divider/counter_reg[0]} .single_bit_orig_name {counter[0]}
set_db -quiet {inst:fractional_n_divider/counter_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:fractional_n_divider/counter_reg[0]/Q} .original_name {counter[0]/q}
set_db -quiet {inst:fractional_n_divider/N_sel_current_reg[1]} .original_name {{N_sel_current[1]}}
set_db -quiet {inst:fractional_n_divider/N_sel_current_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:fractional_n_divider/N_sel_current_reg[1]} .single_bit_orig_name {N_sel_current[1]}
set_db -quiet {inst:fractional_n_divider/N_sel_current_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:fractional_n_divider/N_sel_current_reg[1]/Q} .original_name {N_sel_current[1]/q}
set_db -quiet {inst:fractional_n_divider/N_sel_current_reg[0]} .original_name {{N_sel_current[0]}}
set_db -quiet {inst:fractional_n_divider/N_sel_current_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:fractional_n_divider/N_sel_current_reg[0]} .single_bit_orig_name {N_sel_current[0]}
set_db -quiet {inst:fractional_n_divider/N_sel_current_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:fractional_n_divider/N_sel_current_reg[0]/Q} .original_name {N_sel_current[0]/q}
# BEGIN PMBIST SECTION
# END PMBIST SECTION
set_db -quiet source_verbose true
#############################################################
#####   FLOW WRITE   ########################################
##
## Written by Genus(TM) Synthesis Solution version 21.10-p002_1
## flowkit v21.10-d047_1
## Written on 16:04:28 06-Aug 2026
#############################################################
#####   Flow Definitions   ##################################

#############################################################
#####   Step Definitions   ##################################


#############################################################
#####   Attribute Definitions   #############################

if {[is_attribute flow_edit_end_steps -obj_type root]} {set_db flow_edit_end_steps {}}
if {[is_attribute flow_edit_start_steps -obj_type root]} {set_db flow_edit_start_steps {}}
if {[is_attribute flow_footer_tcl -obj_type root]} {set_db flow_footer_tcl {}}
if {[is_attribute flow_header_tcl -obj_type root]} {set_db flow_header_tcl {}}
if {[is_attribute flow_metadata -obj_type root]} {set_db flow_metadata {}}
if {[is_attribute flow_setup_config -obj_type root]} {set_db flow_setup_config {HUDDLE {!!map {}}}}
if {[is_attribute flow_step_begin_tcl -obj_type root]} {set_db flow_step_begin_tcl {}}
if {[is_attribute flow_step_check_tcl -obj_type root]} {set_db flow_step_check_tcl {}}
if {[is_attribute flow_step_end_tcl -obj_type root]} {set_db flow_step_end_tcl {}}
if {[is_attribute flow_step_order -obj_type root]} {set_db flow_step_order {}}
if {[is_attribute flow_summary_tcl -obj_type root]} {set_db flow_summary_tcl {}}
if {[is_attribute flow_template_feature_definition -obj_type root]} {set_db flow_template_feature_definition {}}
if {[is_attribute flow_template_type -obj_type root]} {set_db flow_template_type {}}
if {[is_attribute flow_template_tools -obj_type root]} {set_db flow_template_tools {}}
if {[is_attribute flow_template_version -obj_type root]} {set_db flow_template_version {}}
if {[is_attribute flow_user_templates -obj_type root]} {set_db flow_user_templates {}}


#############################################################
#####   Flow History   ######################################

if {[is_attribute flow_user_templates -obj_type root]} {set_db flow_user_templates {}}
if {[is_attribute flow_plugin_steps -obj_type root]} {set_db flow_plugin_steps {}}
if {[is_attribute flow_template_type -obj_type root]} {set_db flow_template_type {}}
if {[is_attribute flow_template_tools -obj_type root]} {set_db flow_template_tools {}}
if {[is_attribute flow_template_version -obj_type root]} {set_db flow_template_version {}}
if {[is_attribute flow_template_feature_definition -obj_type root]} {set_db flow_template_feature_definition {}}
if {[is_attribute flow_remark -obj_type root]} {set_db flow_remark {}}
if {[is_attribute flow_features -obj_type root]} {set_db flow_features {}}
if {[is_attribute flow_feature_values -obj_type root]} {set_db flow_feature_values {}}
if {[is_attribute flow_write_db_args -obj_type root]} {set_db flow_write_db_args {}}
if {[is_attribute flow_write_db_sdc -obj_type root]} {set_db flow_write_db_sdc true}
if {[is_attribute flow_write_db_common -obj_type root]} {set_db flow_write_db_common false}
if {[is_attribute flow_post_db_overwrite -obj_type root]} {set_db flow_post_db_overwrite {}}
if {[is_attribute flow_step_order -obj_type root]} {set_db flow_step_order {}}
if {[is_attribute flow_step_begin_tcl -obj_type root]} {set_db flow_step_begin_tcl {}}
if {[is_attribute flow_step_end_tcl -obj_type root]} {set_db flow_step_end_tcl {}}
if {[is_attribute flow_step_last -obj_type root]} {set_db flow_step_last {}}
if {[is_attribute flow_step_current -obj_type root]} {set_db flow_step_current {}}
if {[is_attribute flow_step_canonical_current -obj_type root]} {set_db flow_step_canonical_current {}}
if {[is_attribute flow_step_next -obj_type root]} {set_db flow_step_next {}}
if {[is_attribute flow_working_directory -obj_type root]} {set_db flow_working_directory .}
if {[is_attribute flow_branch -obj_type root]} {set_db flow_branch {}}
if {[is_attribute flow_caller_data -obj_type root]} {set_db flow_caller_data {}}
if {[is_attribute flow_metrics_snapshot_uuid -obj_type root]} {set_db flow_metrics_snapshot_uuid 4e5fb459-61aa-4ecd-bb04-42600fa1f260}
if {[is_attribute flow_starting_db -obj_type root]} {set_db flow_starting_db {}}
if {[is_attribute flow_db_directory -obj_type root]} {set_db flow_db_directory dbs}
if {[is_attribute flow_report_directory -obj_type root]} {set_db flow_report_directory reports}
if {[is_attribute flow_log_directory -obj_type root]} {set_db flow_log_directory logs}
if {[is_attribute flow_mail_to -obj_type root]} {set_db flow_mail_to {}}
if {[is_attribute flow_exit_when_done -obj_type root]} {set_db flow_exit_when_done false}
if {[is_attribute flow_mail_on_error -obj_type root]} {set_db flow_mail_on_error false}
if {[is_attribute flow_summary_tcl -obj_type root]} {set_db flow_summary_tcl {}}
if {[is_attribute flow_history -obj_type root]} {set_db flow_history {}}
if {[is_attribute flow_step_last_status -obj_type root]} {set_db flow_step_last_status not_run}
if {[is_attribute flow_step_last_msg -obj_type root]} {set_db flow_step_last_msg {}}
if {[is_attribute flow_run_tag -obj_type root]} {set_db flow_run_tag {}}
if {[is_attribute flow_current_cache -obj_type root]} {set_db flow_current_cache {}}
if {[is_attribute flow_step_order_cache -obj_type root]} {set_db flow_step_order_cache {}}
if {[is_attribute flow_step_results_cache -obj_type root]} {set_db flow_step_results_cache {}}
if {[is_attribute flow_metadata -obj_type root]} {set_db flow_metadata {}}
if {[is_attribute flow_execute_in_global -obj_type root]} {set_db flow_execute_in_global true}
if {[is_attribute flow_overwrite_db -obj_type root]} {set_db flow_overwrite_db false}
if {[is_attribute flow_print_run_information -obj_type root]} {set_db flow_print_run_information false}
if {[is_attribute flow_verbose -obj_type root]} {set_db flow_verbose true}
if {[is_attribute flow_print_run_information_full -obj_type root]} {set_db flow_print_run_information_full false}
if {[is_attribute flow_header_tcl -obj_type root]} {set_db flow_header_tcl {}}
if {[is_attribute flow_footer_tcl -obj_type root]} {set_db flow_footer_tcl {}}
if {[is_attribute flow_init_header_tcl -obj_type root]} {set_db flow_init_header_tcl {}}
if {[is_attribute flow_init_footer_tcl -obj_type root]} {set_db flow_init_footer_tcl {}}
if {[is_attribute flow_edit_start_steps -obj_type root]} {set_db flow_edit_start_steps {}}
if {[is_attribute flow_edit_end_steps -obj_type root]} {set_db flow_edit_end_steps {}}
if {[is_attribute flow_step_last_number -obj_type root]} {set_db flow_step_last_number 0}
if {[is_attribute flow_autoload_applets -obj_type root]} {set_db flow_autoload_applets false}
if {[is_attribute flow_autoload_dir -obj_type root]} {set_db flow_autoload_dir error}
if {[is_attribute flow_skip_auto_db_save -obj_type root]} {set_db flow_skip_auto_db_save true}
if {[is_attribute flow_skip_auto_generate_metrics -obj_type root]} {set_db flow_skip_auto_generate_metrics false}
if {[is_attribute flow_top -obj_type root]} {set_db flow_top {}}
if {[is_attribute flow_hier_path -obj_type root]} {set_db flow_hier_path {}}
if {[is_attribute flow_schedule -obj_type root]} {set_db flow_schedule {}}
if {[is_attribute flow_step_check_tcl -obj_type root]} {set_db flow_step_check_tcl {}}
if {[is_attribute flow_script -obj_type root]} {set_db flow_script {}}
if {[is_attribute flow_yaml_script -obj_type root]} {set_db flow_yaml_script {}}
if {[is_attribute flow_cla_enabled_features -obj_type root]} {set_db flow_cla_enabled_features {}}
if {[is_attribute flow_cla_inject_tcl -obj_type root]} {set_db flow_cla_inject_tcl {}}
if {[is_attribute flow_error_message -obj_type root]} {set_db flow_error_message {}}
if {[is_attribute flow_error_errorinfo -obj_type root]} {set_db flow_error_errorinfo {}}
if {[is_attribute flow_reset_time_after_flow_init -obj_type root]} {set_db flow_reset_time_after_flow_init false}
if {[is_attribute flow_error_write_db -obj_type root]} {set_db flow_error_write_db true}
if {[is_attribute flow_advanced_metric_isolation -obj_type root]} {set_db flow_advanced_metric_isolation flow}
if {[is_attribute flow_yaml_root -obj_type root]} {set_db flow_yaml_root {}}
if {[is_attribute flow_yaml_root_dir -obj_type root]} {set_db flow_yaml_root_dir {}}
if {[is_attribute flow_setup_config -obj_type root]} {set_db flow_setup_config {HUDDLE {!!map {}}}}
if {[is_attribute flow_yamllint_exec -obj_type root]} {set_db flow_yamllint_exec yamllint}

#############################################################
#####   User Defined Attributes   ###########################
