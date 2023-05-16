`timescale 1ns/1ps
`default_nettype none

module nnt_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter ADDR_LEN = 2**16;
    parameter DATA_LEN = 32;
    parameter LAYER_COUNT = 2;
    logic clk_i, reset_i;

    nnt #(
        .ADDR_LEN(ADDR_LEN),
        .DATA_LEN(DATA_LEN),
        .LAYER_COUNT(LAYER_COUNT)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("nnt.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;
        repeat(100) @(negedge clk_i);

        $finish;
    end

endmodule
