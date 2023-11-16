IVERILOG=iverilog -DSIMULATION -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -g2012 -Y.sv -I ./hdl -I ./testbenches -o
VVP=vvp
VVP_POST=-fst
VIVADO=vivado -mode batch -source
SRCS=hdl/*.sv

.PHONY: clean submission remove_solutions

clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml *.out *.gtkw
	rm -rf .Xil

program_fpga_vivado: $(SRCS) $(MAIN_MEMSMEMORIES) build.tcl program.tcl Nexys-4-Master.xdc
	@echo "########################################"
	@echo "#### Building FPGA bitstream        ####"
	@echo "########################################"
	${VIVADO} build.tcl
	@echo "########################################"
	@echo "#### Programming FPGA (Vivado)      ####"
	@echo "########################################"
	${VIVADO} program.tcl

create_module_template : build_scripts/create_module_template.py
	python3 ./build_scripts/create_module_template.py $(filter-out $@,$(MAKECMDGOALS))
%:
	@:

create_testbench_templates : build_scripts/create_testbench_templates.py
	python3 ./build_scripts/create_testbench_templates.py

add_signal : build_scripts/add_signal.py
	python3 ./build_scripts/add_signal.py $(filter-out $@,$(MAKECMDGOALS))
%:
	@:
	
test_systolic_arithmetic_node : testbenches/systolic_arithmetic_node_tb.sv hdl/*
	${IVERILOG} systolic_arithmetic_node.bin ./testbenches/systolic_arithmetic_node_tb.sv ./hdl/systolic_arithmetic_node.sv && ${VVP} systolic_arithmetic_node.bin ${VVP_POST}

wave_systolic_arithmetic_node : testbenches/systolic_arithmetic_node_tb.sv
	gtkwave systolic_arithmetic_node.fst --save=systolic_arithmetic_node.gtkw

test_systolic_array : testbenches/systolic_array_tb.sv hdl/*
	${IVERILOG} systolic_array.bin ./testbenches/systolic_array_tb.sv ./hdl/systolic_array.sv ./hdl/systolic_arithmetic_node.sv && ${VVP} systolic_array.bin ${VVP_POST}

wave_systolic_array : testbenches/systolic_array_tb.sv
	gtkwave systolic_array.fst --save=systolic_array.gtkw

test_row_selector : testbenches/row_selector_tb.sv hdl/*
	${IVERILOG} row_selector.bin ./testbenches/row_selector_tb.sv ./hdl/row_selector.sv && ${VVP} row_selector.bin ${VVP_POST}

wave_row_selector : testbenches/row_selector_tb.sv
	gtkwave row_selector.fst --save=row_selector.gtkw

