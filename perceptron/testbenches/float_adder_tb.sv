`timescale 1ns/1ps
`default_nettype none

module float_adder_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter q_m = 17;
    parameter q_n = 16;
    logic clk_i;
    logic [q_m + q_n -1:0] a_in, b_in;
    wire [q_m + q_n - 1:0] y_out;

    float_adder #(
    .q_m(q_m),
    .q_n(q_n)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("float_adder.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        repeat(1) @(negedge clk_i);
        a_in = 123;
        b_in = 146;
        repeat(1) @(negedge clk_i);
        assert(y_out == 269) $display("Two positive numbers");
        a_in = -123;
        b_in = 146;
        repeat(1) @(negedge clk_i);
        assert(y_out == 23) $display("One negative one positive number");
        a_in = -123;
        b_in = -146;
        repeat(1) @(negedge clk_i);
        assert(y_out == -269) $display("Two Negative numbers");
        a_in = 0;
        b_in = -146;
        repeat(1) @(negedge clk_i);
        assert(y_out == -146) $display("0 and Negative number");
        $finish;
    end

endmodule
