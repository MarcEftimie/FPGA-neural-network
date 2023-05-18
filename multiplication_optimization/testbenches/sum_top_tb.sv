`timescale 1ns/1ps
`default_nettype none

module sum_top_tb;

    parameter WIDTH = 32;
    parameter CLK_PERIOD_NS = 10;
    logic clk_i;
    logic  [WIDTH-1:0] a;
    logic  [WIDTH-1:0] b;
    wire [WIDTH-1:0] sum;

    sum_top #(
        .WIDTH(WIDTH)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("sum_top.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        repeat(1) @(negedge clk_i);
        a = 32'h3f800000;
        b = 32'h3f800000;
        repeat(1) @(negedge clk_i);
        a = 32'h40000000;
        b = 32'h40000000;
        repeat(1) @(negedge clk_i);
        a = 32'h40200000;
        b = 32'h40200000;
        repeat(1) @(negedge clk_i);
        $finish;
    end

endmodule
