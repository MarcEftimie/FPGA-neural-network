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
	
test_multiplier : testbenches/multiplier_tb.sv hdl/*
	${IVERILOG} multiplier.bin ./testbenches/multiplier_tb.sv ./hdl/multiplier.sv && ${VVP} multiplier.bin ${VVP_POST}

wave_multiplier : testbenches/multiplier_tb.sv
	gtkwave multiplier.fst --save=multiplier.gtkw

test_overflow_underflow_rectifier : testbenches/overflow_underflow_rectifier_tb.sv hdl/*
	${IVERILOG} overflow_underflow_rectifier.bin ./testbenches/overflow_underflow_rectifier_tb.sv ./hdl/overflow_underflow_rectifier.sv && ${VVP} overflow_underflow_rectifier.bin ${VVP_POST}

wave_overflow_underflow_rectifier : testbenches/overflow_underflow_rectifier_tb.sv
	gtkwave overflow_underflow_rectifier.fst --save=overflow_underflow_rectifier.gtkwtest_signed_fixed_point_multiplier : testbenches/signed_fixed_point_multiplier_tb.sv hdl/*
	${IVERILOG} signed_fixed_point_multiplier.bin ./testbenches/signed_fixed_point_multiplier_tb.sv ./hdl/signed_fixed_point_multiplier.sv && ${VVP} signed_fixed_point_multiplier.bin ${VVP_POST}

test_signed_fixed_point_multiplier : testbenches/signed_fixed_point_multiplier_tb.sv hdl/*
	${IVERILOG} signed_fixed_point_multiplier.bin ./testbenches/signed_fixed_point_multiplier_tb.sv ./hdl/* && ${VVP} signed_fixed_point_multiplier.bin ${VVP_POST}

wave_signed_fixed_point_multiplier : testbenches/signed_fixed_point_multiplier_tb.sv
	gtkwave signed_fixed_point_multiplier.fst --save=signed_fixed_point_multiplier.gtkw
	
test_adder : testbenches/adder_tb.sv hdl/*
	${IVERILOG} adder.bin ./testbenches/adder_tb.sv ./hdl/adder.sv && ${VVP} adder.bin ${VVP_POST}

wave_adder : testbenches/adder_tb.sv
	gtkwave adder.fst --save=adder.gtkw

test_cascaded_adder_chain : testbenches/cascaded_adder_chain_tb.sv hdl/*
	${IVERILOG} cascaded_adder_chain.bin ./testbenches/cascaded_adder_chain_tb.sv ./hdl/cascaded_adder_chain.sv ./hdl/overflow_underflow_rectifier.sv && ${VVP} cascaded_adder_chain.bin ${VVP_POST}

wave_cascaded_adder_chain : testbenches/cascaded_adder_chain_tb.sv
	gtkwave cascaded_adder_chain.fst --save=cascaded_adder_chain.gtkw

test_vector_multiplier : testbenches/vector_multiplier_tb.sv hdl/*
	${IVERILOG} vector_multiplier.bin ./testbenches/vector_multiplier_tb.sv ./hdl/* && ${VVP} vector_multiplier.bin ${VVP_POST}

wave_vector_multiplier : testbenches/vector_multiplier_tb.sv
	gtkwave vector_multiplier.fst --save=vector_multiplier.gtkw
