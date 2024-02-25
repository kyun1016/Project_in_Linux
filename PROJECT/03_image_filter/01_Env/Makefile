# export SELECT_VERSION_xrun=21.09.006_xcelium
# export SPYGLASS_HOME=/cad/synopsys/spyglass/S-2021.09-SP2-1/SPYGLASS_HOME
# export SPYGLASS_DC_PATH=/cad/synopsys/spyglass/S-2021.09-SP2-1
dir = ~/Project_in_Linux/PROJECT/03_image_filter
vcs_option = -full64 -cpp g++-4.8 -cc gcc-4.8 -LDFLAGS -Wl,--no-as-needed -sverilog -timescale=1ns/1ns -kdb -debug_access+all +v2k -cm line+cond+fsm+tgl+branch 
simv_option = -reportstats -cm line+cond+fsm+tgl+branch 
urg_option = -full64
date = $(shell date '+%m%d_%H%M')

all: vcs

default_setting:
		mkdir ${dir}/02_Sim/01_func/1_top
		mkdir ${dir}/02_Sim/01_func/1_top/01_log
		mkdir ${dir}/02_Sim/01_func/1_top/02_exe
		mkdir ${dir}/02_Sim/01_func/1_top/03_fsdb

vcs:
		cd ${dir}/02_Sim/01_func/1_top ;\
		vcs ${vcs_option} -F ${dir}/01_Env/02_Source_Code/list_top.f -l ./01_log/vcs_${date}.log -o ./02_exe/simv ;\
		./02_exe/simv ${simv_option} -l ./01_log/simv_${date}.log -cm_dir ./02_exe/simv.vdb -cm_name test_000
		
vd:
		cd ${dir}/02_Sim/01_func/1_top ;\
		verdi -dbdir ./02_exe/simv.daidir -ssf ./03_fsdb/waveform.fsdb &

vdf:
		cd ${dir}/02_Sim/01_func/1_top ;\
		verdi -F ${dir}/01_Env/02_Source_Code/list_top.f &

vdcc:
		cd ${dir}/02_Sim/01_func/1_top ;\
		verdi -cov -covdir ./02_exe/simv.vdb &

urg:
		cd ${dir}/02_Sim/01_func/1_top ;\
		urg ${urg_option} -dir ./02_exe/simv.vdb &

lint:
		echo "==== directory list ===="
		ls ${dir}/03_Lint/.
		@read -p "Type Directory Name: " dir_name ;\
		rm -r ${dir}/03_Lint/$${dir_name} ;\
		mkdir ${dir}/03_Lint/$${dir_name} ;\
		mkdir ${dir}/03_Lint/$${dir_name}/01_script ;\
		mkdir ${dir}/03_Lint/$${dir_name}/01_script/01_RTL ;\
		mkdir ${dir}/03_Lint/$${dir_name}/02_logs ;\
		mkdir ${dir}/03_Lint/$${dir_name}/03_rpts ;\
		cp ${dir}/01_Env/04_Lint/run.tcl ${dir}/03_Lint/$${dir_name}/01_script ;\
		cp ${dir}/01_Env/02_Source_Code/06_RTL_Code/*.v ${dir}/03_Lint/$${dir_name}/01_script/01_RTL/. ;\
		cd ${dir}/03_Lint/$${dir_name} ;\
		ls 01_script/01_RTL/*.v > ./01_script/01_RTL/list_rtl.f ;\
		spyglass & 	
