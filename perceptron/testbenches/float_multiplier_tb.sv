`timescale 1ns/1ps
`default_nettype none

module float_multiplier_tb;

    parameter CLK_PERIOD_NS = 10;
    logic clk_i, reset_i;
    logic [31:0] a_in, b_in;
    wire [31:0] y_out;

    float_multiplier #(
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("float_multiplier.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;
        repeat(1) @(negedge clk_i);
        a_in = 0.5;
        b_in = 0.5;
        repeat(1) @(negedge clk_i);
        $finish;
    end

endmodule
