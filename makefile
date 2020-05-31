export VIVADO_PATH=/tools/Xilinx/Vivado/2018.3/bin/vivado
PROJECT_DIR:=.
SIM:=sim_1
PROJECT_NAME:=mips-bpb

test: 
	SIMULATION=${SIM} ${VIVADO_PATH} -mode tcl -source benchtest/run_simulation.tcl ${PROJECT_DIR}/${PROJECT_NAME}.xpr
	
