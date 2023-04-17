`timescale 1ns/1ps
`default_nettype none

module perceptron_top_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter HELLO = 1;
    parameter HELLO2 = 1;
    logic [1:0] clk_i, reset_i, btn_i;
    wire [1:0] out1, led1;
    wire sda;

    perceptron_top #(
    .HELLO(HELLO),
    .HELLO2(HELLO2)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("perceptron_top.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;
        $finish;
    end

endmodule
