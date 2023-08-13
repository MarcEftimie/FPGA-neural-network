`timescale 1ns/1ps
`default_nettype none

module cascaded_adder_chain_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter ADDEND_WIDTH = 16;
    parameter SUM_WIDTH = ADDEND_WIDTH;
    parameter NUMBER_OF_ADDENDS = 64;
    logic clk_in;
    logic [NUMBER_OF_ADDENDS-1:0][ADDEND_WIDTH-1:0] addends_in;
    wire [SUM_WIDTH-1:0] sum_out;

    cascaded_adder_chain #(
        .ADDEND_WIDTH(ADDEND_WIDTH),
        .SUM_WIDTH(SUM_WIDTH),
        .NUMBER_OF_ADDENDS(NUMBER_OF_ADDENDS)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_in = ~clk_in;

    initial begin
        $dumpfile("cascaded_adder_chain.fst");
        $dumpvars(0, UUT);
        clk_in = 0;
        reset_i = 1;
        repeat(1) @(negedge clk_in);
        reset_i = 0;
        $finish;
    end

endmodule
