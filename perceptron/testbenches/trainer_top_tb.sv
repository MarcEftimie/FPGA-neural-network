`timescale 1ns/1ps
`default_nettype none

module trainer_top_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter TRAIN_ITERATIONS = 5;
    parameter LEARNING_RATE =    32'b0_000000000000001_0000000000000000;
    parameter INIT_WEIGHT_1 =    32'b0_000000000000000_0010000000000000;
    parameter INIT_WEIGHT_2 =    32'b1_000000000000000_1000000000000000;
    parameter INIT_WEIGHT_BIAS = 32'b0_000000000000000_0100000000000000;
    parameter BIAS =             32'b0_000000000000001_0000000000000000;
    parameter SIGN = 1;
    parameter Q_M = 15;
    parameter Q_N = 16;
    logic clk_i, reset_i;

    trainer_top #(
        .TRAIN_ITERATIONS(TRAIN_ITERATIONS),
        .LEARNING_RATE(LEARNING_RATE),
        .INIT_WEIGHT_1(INIT_WEIGHT_1),
        .INIT_WEIGHT_2(INIT_WEIGHT_2),
        .INIT_WEIGHT_BIAS(INIT_WEIGHT_BIAS),
        .BIAS(BIAS),
        .SIGN(SIGN),
        .Q_M(Q_M),
        .Q_N(Q_N)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("trainer_top.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;
        repeat(50) @(negedge clk_i);
        $finish;
    end

endmodule
