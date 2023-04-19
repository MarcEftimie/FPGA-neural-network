`timescale 1ns/1ps
`default_nettype none

module activation_function_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter SIGN = 1;
    parameter Q_M = 16;
    parameter Q_N = 16;
    logic clk_i;
    logic [(SIGN + Q_M + Q_N) - 1:0] summation;
    wire activation;

    activation_function #(
    .SIGN(SIGN),
    .Q_M(Q_M),
    .Q_N(Q_N)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("activation_function.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        repeat(1) @(negedge clk_i);

        summation = 0;
        repeat(1) @(negedge clk_i);
        summation = 33'b111111111111111111111111111111111;
        repeat(1) @(negedge clk_i);
        summation = 1;
        repeat(1) @(negedge clk_i);

        $finish;
    end

endmodule
