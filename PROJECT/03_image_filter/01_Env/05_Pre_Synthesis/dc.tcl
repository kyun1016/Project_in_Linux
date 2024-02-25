set dir ~/Project_in_Linux/PROJECT/03_image_filter
set rtl_dir ${dir}/01_Env/02_Source_Code/06_RTL_Code
set top_design rtl_top

set target_library gtech.db
set symbol_library generic.sdb
set link_library [concat $target_library "*"]
set search_path [concat $search_path]

# read_file -format verilog { \
#   ${rtl_dir}/apb_slave.v                  \
#   ${rtl_dir}/csc_mat_mul_3x3.v            \
#   ${rtl_dir}/icsc_mat_mul_3x3.v           \
#   ${rtl_dir}/simple_dual_one_clock.v      \
#   ${rtl_dir}/filter_data_align_5x5.v      \
#   ${rtl_dir}/filter_conv_5x5.v            \
#   ${rtl_dir}/filter_fsm.v                 \
#   ${rtl_dir}/filter_top_5x5.v             \
#   ${rtl_dir}/filter_control.v             \
#   ${rtl_dir}/filter_data_align_5x5_new.v  \
#   ${rtl_dir}/filter_top_5x5_new.v         \
#   ${rtl_dir}/rtl_top.v                    \
# }
read_verilog ${rtl_dir}/simple_dual_one_clock.v    
read_verilog ${rtl_dir}/apb_slave.v                
read_verilog ${rtl_dir}/filter_fsm.v               
read_verilog ${rtl_dir}/filter_control.v           
read_verilog ${rtl_dir}/filter_conv_5x5.v          
read_verilog ${rtl_dir}/filter_data_align_5x5.v    
read_verilog ${rtl_dir}/filter_data_align_5x5_new.v
read_verilog ${rtl_dir}/filter_top_5x5.v           
read_verilog ${rtl_dir}/filter_top_5x5_new.v       
read_verilog ${rtl_dir}/csc_mat_mul_3x3.v          
read_verilog ${rtl_dir}/icsc_mat_mul_3x3.v         
read_verilog ${rtl_dir}/rtl_top.v                  

analyze -format verilog ${rtl_dir}/simple_dual_one_clock.v    
analyze -format verilog ${rtl_dir}/apb_slave.v                
analyze -format verilog ${rtl_dir}/filter_fsm.v               
analyze -format verilog ${rtl_dir}/filter_control.v           
analyze -format verilog ${rtl_dir}/filter_conv_5x5.v          
analyze -format verilog ${rtl_dir}/filter_data_align_5x5.v    
analyze -format verilog ${rtl_dir}/filter_data_align_5x5_new.v
analyze -format verilog ${rtl_dir}/filter_top_5x5.v           
analyze -format verilog ${rtl_dir}/filter_top_5x5_new.v       
analyze -format verilog ${rtl_dir}/csc_mat_mul_3x3.v          
analyze -format verilog ${rtl_dir}/icsc_mat_mul_3x3.v         
analyze -format verilog ${rtl_dir}/rtl_top.v                  
elaborate ${top_design}
link
check_design
current_design ${top_design}

compile_ultra -scan -no_autoungroup -no_seq_output_inversion

write -format verilog -hierarchy -output ./3_out/top.v
write -format ddc -hierarchy -output ./3_out/top.ddc
write_sdf ./3_out/top.sdf

# set_wire_load "10x10"
# set_operating_conditions WCCOM

# set_arrival .1 X 
# set_drive 1 all_inputs()
# set_load 4 all_outputs()

# create_clock -period 8 -waveform {0 4} {CLOCK}

# set_fsm_encoding { "S0=2#00" "S1=2#10" "S2=2#01" "S3=2#11" }		
# set_fsm_minimize true

# compile

