`timescale 1ns/1ps
`default_nettype none

module fixed_point_adder_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter sign = 1;
    parameter q_m = 16;
    parameter q_n = 16;
    logic clk_i;
    logic [sign + q_m + q_n -1:0] x1_in, x2_in, b_in;
    wire [sign + q_m + q_n - 1:0] y_out;

    fixed_point_adder #(
    .sign(sign),
    .q_m(q_m),
    .q_n(q_n)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("fixed_point_adder.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        b_in = 0;
        repeat(1) @(negedge clk_i);
        x1_in = 123;
        x2_in = 146;
        repeat(1) @(negedge clk_i);
        assert(y_out == 269) $display("Two positive numbers");
        x1_in = -123;
        x2_in = 146;
        repeat(1) @(negedge clk_i);
        assert(y_out == 23) $display("One negative one positive number");
        x1_in = -123;
        x2_in = -146;
        repeat(1) @(negedge clk_i);
        assert(y_out == -269) $display("Two Negative numbers");
        x1_in = 0;
        x2_in = -146;
        repeat(1) @(negedge clk_i);
        assert(y_out == -146) $display("0 and Negative number");
        $finish;
    end

endmodule
