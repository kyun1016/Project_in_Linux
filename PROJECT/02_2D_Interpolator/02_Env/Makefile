# export SELECT_VERSION_xrun=21.09.006_xcelium
# export SPYGLASS_HOME=/cad/synopsys/spyglass/S-2021.09-SP2-1/SPYGLASS_HOME
# export SPYGLASS_DC_PATH=/cad/synopsys/spyglass/S-2021.09-SP2-1
dir = ~/PROJECT/02_2D_Interpolator


all: vcs

vcs:
		echo "==== directory list ===="
		ls ${dir}/03_Sim/1_func/.
		@read -p "Type Directory Name: " dir_name ;\
		rm -r ${dir}/03_Sim/1_func/$${dir_name}/01_log ;\
		mkdir ${dir}/03_Sim/1_func/$${dir_name} ;\
		mkdir ${dir}/03_Sim/1_func/$${dir_name}/01_log ;\
		mkdir ${dir}/03_Sim/1_func/$${dir_name}/02_cc ;\
		mkdir ${dir}/03_Sim/1_func/$${dir_name}/03_fsdb ;\
		cd ${dir}/03_Sim/1_func/$${dir_name}/. ;\
		vcs -full64 -cpp g++-4.8 -cc gcc-4.8 -LDFLAGS -Wl,--no-as-needed \
		-sverilog -timescale=1ns/1ns -F ${dir}/02_Env/01_Source_Code/list_top.f -l ./01_log/fsim.log \
		-kdb -debug_access+all -lca +V2K \
		-cm line+cond+fsm+tgl+branch \
		-o ./simv ;\
		./simv -reportstats -l ./01_log/vcs_sim.log \
		-cm line+cond+fsm+tgl+branch \
		-cm_hier ./02_cc/.
		
vd:
		echo "==== directory list ===="
		ls ${dir}/03_Sim/1_func/.
		@read -p "Type Directory Name: " dir_name ;\
		cd ${dir}/03_Sim/1_func/$${dir_name}/. ;\
		verdi -dbdir ./simv.daidir -ssf ./03_fsdb/waveform.fsdb &
cc:
		echo "==== directory list ===="
		ls ${dir}/03_Sim/1_func/.
		@read -p "Type Directory Name: " dir_name ;\
		cd ${dir}/03_Sim/1_func/$${dir_name}/. ;\
		verdi -cov -covdir ./simv.vdb &

lint:
		echo "==== directory list ===="
		ls ${dir}/04_Lint/.
		@read -p "Type Directory Name: " dir_name ;\
		rm -r ${dir}/04_Lint/$${dir_name} ;\
		mkdir ${dir}/04_Lint/$${dir_name} ;\
		mkdir ${dir}/04_Lint/$${dir_name}/01_script ;\
		mkdir ${dir}/04_Lint/$${dir_name}/02_logs ;\
		mkdir ${dir}/04_Lint/$${dir_name}/03_rpts ;\
		cp ./01_Lint/run.tcl ../05_Lint/$${dir_name}/01_script ;\
		cd ../05_Lint/$${dir_name} ;\
		spyglass & 	
