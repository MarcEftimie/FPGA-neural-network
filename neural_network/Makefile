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


test_neural_network_top : testbenches/neural_network_top_tb.sv hdl/*
	${IVERILOG} $^ -o neural_network_top_tb.bin && ${VVP} neural_network_top_tb.bin ${VVP_POST} && gtkwave neural_network_top.fst -a testbenches/sy

test_bram : testbenches/bram_tb.sv hdl/*
	${IVERILOG} $^ -o bram_tb.bin && ${VVP} bram_tb.bin ${VVP_POST} && gtkwave bram.fst -a testbenches/sy

test_multiplier : testbenches/multiplier_tb.sv hdl/*
	${IVERILOG} $^ -o multiplier_tb.bin && ${VVP} multiplier_tb.bin ${VVP_POST} && gtkwave multiplier.fst -a testbenches/sy

test_nnt : testbenches/nnt_tb.sv hdl/nnt.sv hdl/bram.sv
	${IVERILOG} $^ -o nnt_tb.bin && ${VVP} nnt_tb.bin ${VVP_POST} && gtkwave nnt.fst -a testbenches/sy

