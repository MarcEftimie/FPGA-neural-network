`timescale 1ns/1ps
`default_nettype none

module vector_multiplier_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter VECTOR_LENGTH = 64;
    parameter FIXED_POINT_WIDTH = 16;
    parameter FIXED_POINT_POSITION = 10;
    logic clk_in;
    logic [VECTOR_LENGTH-1:0][FIXED_POINT_WIDTH-1:0] vector_1_in;
    logic [VECTOR_LENGTH-1:0][FIXED_POINT_WIDTH-1:0] vector_2_in;
    wire [FIXED_POINT_WIDTH-1:0] product_out;

    int i;

    vector_multiplier #(
        .VECTOR_LENGTH(VECTOR_LENGTH),
        .FIXED_POINT_WIDTH(FIXED_POINT_WIDTH),
        .FIXED_POINT_POSITION(FIXED_POINT_POSITION)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_in = ~clk_in;

    initial begin
        $dumpfile("vector_multiplier.fst");
        $dumpvars(0, UUT);
        clk_in = 0;
        repeat(1) @(negedge clk_in);
        for (i=0; i<VECTOR_LENGTH; i++) begin
            vector_1_in[i] = 1024/2;
            vector_2_in[i] = 1024/2;
        end
        repeat(10) @(negedge clk_in);
        $finish;
    end

endmodule
