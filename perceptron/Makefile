IVERILOG=iverilog -DSIMULATION -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -g2012 -Y.sv -I ./hdl -I ./tests 
VVP=vvp
VVP_POST=-fst
VIVADO=vivado -mode batch -source
SRCS=hdl/*.sv

.PHONY: clean submission remove_solutions

clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml *.out
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

test_perceptron_top : testbenches/perceptron_top_tb.sv hdl/*
	${IVERILOG} $^ -o perceptron_top_tb.bin && ${VVP} perceptron_top_tb.bin ${VVP_POST} && gtkwave perceptron_top.fst -a testbenches/sy
test_fixed_point_multiplier : testbenches/fixed_point_multiplier_tb.sv hdl/*
	${IVERILOG} $^ -o fixed_point_multiplier_tb.bin && ${VVP} fixed_point_multiplier_tb.bin ${VVP_POST} && gtkwave fixed_point_multiplier.fst -a testbenches/sy

test_fixed_point_adder : testbenches/fixed_point_adder_tb.sv hdl/*
	${IVERILOG} $^ -o fixed_point_adder_tb.bin && ${VVP} fixed_point_adder_tb.bin ${VVP_POST} && gtkwave fixed_point_adder.fst -a testbenches/sy
test_activation_function : testbenches/activation_function_tb.sv hdl/*
	${IVERILOG} $^ -o activation_function_tb.bin && ${VVP} activation_function_tb.bin ${VVP_POST} && gtkwave activation_function.fst -a testbenches/sy

# test_neuron : testbenches/neuron_tb.sv hdl/*
# 	${IVERILOG} $^ -o neuron_tb.bin && ${VVP} neuron_tb.bin ${VVP_POST} && gtkwave neuron.fst -a testbenches/sy

# test_neuron_trainer : testbenches/neuron_trainer_tb.sv hdl/*
# 	${IVERILOG} $^ -o neuron_trainer_tb.bin && ${VVP} neuron_trainer_tb.bin ${VVP_POST} && gtkwave neuron_trainer.fst -a testbenches/sy

test_sigmoid_function : testbenches/sigmoid_function_tb.sv hdl/sigmoid_function.sv
	${IVERILOG} $^ -o sigmoid_function_tb.bin && ${VVP} sigmoid_function_tb.bin ${VVP_POST} && gtkwave sigmoid_function.fst -a testbenches/sy

test_trainer_top : testbenches/trainer_top_tb.sv hdl/*
	${IVERILOG} $^ -o trainer_top_tb.bin && ${VVP} trainer_top_tb.bin ${VVP_POST} && gtkwave trainer_top.fst -a testbenches/sy

