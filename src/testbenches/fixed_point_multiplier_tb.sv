`timescale 1ns/1ps
`default_nettype none

module fixed_point_multiplier_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter FIXED_POINT_LENGTH = 16;
    parameter FIXED_POINT_POSITION = 10;
    logic clk_in;
    logic [FIXED_POINT_LENGTH-1:0] fixed_point_1_in;
    logic [FIXED_POINT_LENGTH-1:0] fixed_point_2_in;
    wire [FIXED_POINT_LENGTH-1:0] product_out;

    fixed_point_multiplier #(
        .FIXED_POINT_LENGTH(FIXED_POINT_LENGTH),
        .FIXED_POINT_POSITION(FIXED_POINT_POSITION)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_in = ~clk_in;

    initial begin
        $dumpfile("fixed_point_multiplier.fst");
        $dumpvars(0, UUT);
        clk_in = 0;
        repeat(1) @(negedge clk_in);
        fixed_point_1_in = 2**10;
        fixed_point_2_in = 2**10;
        repeat(10) @(negedge clk_in);
        $finish;
    end

endmodule
