`timescale 1ns/1ps
`default_nettype none

module cascaded_adder_chain_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter ADDEND_WIDTH = 16;
    parameter FINAL_SUM_WIDTH = ADDEND_WIDTH;
    parameter NUMBER_OF_ADDENDS = 64;
    logic clk_in;
    logic [NUMBER_OF_ADDENDS-1:0][ADDEND_WIDTH-1:0] addends_in;
    wire [FINAL_SUM_WIDTH-1:0] sum_out;
    int i;

    cascaded_adder_chain #(
        .ADDEND_WIDTH(ADDEND_WIDTH),
        .FINAL_SUM_WIDTH(FINAL_SUM_WIDTH),
        .NUMBER_OF_ADDENDS(NUMBER_OF_ADDENDS)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_in = ~clk_in;

    initial begin
        $dumpfile("cascaded_adder_chain.fst");
        $dumpvars(0, UUT);
        clk_in = 0;
        repeat(1) @(negedge clk_in);
        for (i=0; i<NUMBER_OF_ADDENDS; i++) begin
            addends_in[i] = 2;
        end
        repeat(10) @(negedge clk_in);
        $finish;
    end

endmodule
