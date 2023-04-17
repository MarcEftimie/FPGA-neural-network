`timescale 1ns/1ps
`default_nettype none

module fixed_point_multiplier_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter sign = 1;
    parameter q_m = 16;
    parameter q_n = 16;
    logic clk_i;
    logic [(sign+q_m+q_n)-1:0] a_in;
    logic [(sign+q_m+q_n)-1:0] b_in;
    wire [(sign+q_m+q_n)-1:0] y_out;

    fixed_point_multiplier #(
    .sign(sign),
    .q_m(q_m),
    .q_n(q_n)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("fixed_point_multiplier.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        repeat(1) @(negedge clk_i);

        a_in = 33'b0_0000000000000000_1000000000000000;
        b_in = 33'b0_0000000000000000_1000000000000000;
        repeat(1) @(negedge clk_i);
        assert (y_out == 33'b0_0000000000000000_0100000000000000) $display("Two positive floats.");

        repeat(1) @(negedge clk_i);
        a_in = 33'b1_0000000000000000_1000000000000000;
        b_in = 33'b1_0000000000000000_1000000000000000;
        repeat(1) @(negedge clk_i);
        assert (y_out == 33'b0_0000000000000000_0100000000000000) $display("Two negative floats.");

        a_in = 33'b1_0000000000000000_1000000000000000;
        b_in = 33'b0_0000000000000000_1000000000000000;
        repeat(1) @(negedge clk_i);
        assert (y_out == 33'b1_0000000000000000_0100000000000000) $display("Different signed floats.");
        repeat(1) @(negedge clk_i);

        a_in = 33'b0_0000000000000001_1000000000000000;
        b_in = 33'b0_0000000000000001_1000000000000000;
        repeat(1) @(negedge clk_i);
        assert (y_out == 33'b0_0000000000000010_0100000000000000) $display("Int times int.");

        a_in = 33'b0_0000000000000001_1000000000000000;
        b_in = 33'b0_0000000000000000_1000000000000000;
        repeat(1) @(negedge clk_i);
        assert (y_out == 33'b0_0000000000000000_1100000000000000) $display("Int times float.");

        a_in = 33'b0_0000000000000001_1000000000000000;
        b_in = 33'b0_0000000000000000_1000000000000000;
        repeat(1) @(negedge clk_i);
        assert (y_out == 33'b0_0000000000000000_1100000000000000) $display("Int times float.");

        a_in = 33'b0_0000000000000000_0001111110011000;
        b_in = 33'b0_0000000000000000_0001111110011000;
        repeat(1) @(negedge clk_i);
        assert (y_out == 33'b0_0000000000000000_0000001111100110) $display("Large floats.");

        $finish;
    end

endmodule
