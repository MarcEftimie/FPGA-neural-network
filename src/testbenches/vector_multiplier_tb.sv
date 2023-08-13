`timescale 1ns/1ps
`default_nettype none

module vector_multiplier_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter VECTOR_LENGTH = 16;
    parameter FIXED_POINT_LENGTH = 16;
    parameter FIXED_POINT_POSITION = 10;
    logic clk_in;
    logic [VECTOR_LENGTH*FIXED_POINT_LENGTH-1:0] vector_1_in;
    logic [VECTOR_LENGTH*FIXED_POINT_LENGTH-1:0] vector_2_in;
    wire [FIXED_POINT_LENGTH-1:0] product_out;

    vector_multiplier #(
        .VECTOR_LENGTH(VECTOR_LENGTH),
        .FIXED_POINT_LENGTH(FIXED_POINT_LENGTH),
        .FIXED_POINT_POSITION(FIXED_POINT_POSITION)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_in = ~clk_in;

    initial begin
        $dumpfile("vector_multiplier.fst");
        $dumpvars(0, UUT);
        clk_in = 0;
        reset_i = 1;
        repeat(1) @(negedge clk_in);
        reset_i = 0;
        $finish;
    end

endmodule
