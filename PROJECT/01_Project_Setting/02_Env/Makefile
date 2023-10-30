# export SELECT_VERSION_xrun=21.09.006_xcelium
# export SPYGLASS_HOME=/cad/synopsys/spyglass/S-2021.09-SP2-1/SPYGLASS_HOME
# export SPYGLASS_DC_PATH=/cad/synopsys/spyglass/S-2021.09-SP2-1

all: vcs

vcs:
		echo "==== directory list ===="
		ls -al ../03_Sim/1_func/.
		@read -p "Type Directory Name: " dir_name ;\
		mkdir ../03_Sim/1_func/$${dir_name} ;\
		mkdir ../03_Sim/1_func/$${dir_name}/02_log ;\
		mkdir ../03_Sim/1_func/$${dir_name}/03_fsdb ;\
		cp -r ./01_Source_Code ../03_Sim/1_func/$${dir_name}/. ;\
		cd ../03_Sim/1_func/$${dir_name}/. ;\
		vcs -full64 -cpp g++-4.8 -cc gcc-4.8 -LDFLAGS -Wl,--no-as-needed \
		-sverilog -timescale=1ns/1ns -F ./01_Source_Code/list_top.f -l ./02_log/fsim.log \
		-kdb -debug_access+all -lca +V2K ;\
		./simv
		
vd:
		echo "==== directory list ===="
		ls -al ../03_Sim/1_func/.
		@read -p "Type Directory Name: " dir_name ;\
		cd ../03_Sim/1_func/$${dir_name}/. ;\
		verdi -F ./01_Source_Code/list_top.f -ssf ./1_fsdb/waveform.fsdb &

lint:
		echo "==== directory list ===="
		ls -al ../05_Lint/.
		@read -p "Type Directory Name: " dir_name ;\
		mkdir ../05_Lint/$${dir_name} ;\
		mkdir ../05_Lint/$${dir_name}/01_script ;\
		mkdir ../05_Lint/$${dir_name}/02_logs ;\
		mkdir ../05_Lint/$${dir_name}/03_rpts ;\
		cp ./01_Lint/run.tcl ../05_Lint/$${dir_name}/01_script ;\
		cd ../05_Lint/$${dir_name} ;\
		echo "run simulation"
		
