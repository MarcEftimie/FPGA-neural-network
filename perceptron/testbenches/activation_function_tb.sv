`timescale 1ns/1ps
`default_nettype none

module activation_function_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter sign = 1;
    parameter q_m = 16;
    parameter q_n = 16;
    logic clk_i;
    logic [(sign + q_m + q_n) - 1:0] summation;
    wire activation;

    activation_function #(
    .sign(sign),
    .q_m(q_m),
    .q_n(q_n)
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
