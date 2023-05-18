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


test_multiply_top : testbenches/multiply_top_tb.sv hdl/*
	${IVERILOG} $^ -o multiply_top_tb.bin && ${VVP} multiply_top_tb.bin ${VVP_POST} && gtkwave multiply_top.fst -a testbenches/sy

test_sum_top : testbenches/sum_top_tb.sv hdl/sum_top.sv
	${IVERILOG} $^ -o sum_top_tb.bin && ${VVP} sum_top_tb.bin ${VVP_POST} && gtkwave sum_top.fst -a testbenches/sy

