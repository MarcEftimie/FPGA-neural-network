
`timescale 1ns/1ps
`default_nettype none

module systolic_array_tb;

    parameter CLK_PERIOD_NS = 10;
    
    // UUT Parameters
    parameter SYSTOLIC_ARRAY_ROWS = 8;
    parameter SYSTOLIC_ARRAY_COLS = 8;
    parameter FIXED_POINT_WIDTH = 16;

    // UUT Inputs
    logic clk_in;
    logic weights_valid_in;
    logic [SYSTOLIC_ARRAY_COLS-1:0][FIXED_POINT_WIDTH-1:0] weights_in;
    logic [SYSTOLIC_ARRAY_ROWS-1:0][FIXED_POINT_WIDTH-1:0] activations_in;
    wire [SYSTOLIC_ARRAY_COLS-1:0][FIXED_POINT_WIDTH-1:0] sum_out;

    // UUT Outputs


    // Test Hyperparameters
    parameter TEST_COUNT = 1;
    string MEM_PATH = "./mem/test_vectors/systolic_array/";

    // Test Vectors
    logic [1-1:0] xx [0:TEST_COUNT-1];

    // task automatic readMem();
    //    $readmemb({MEM_PATH, xx".mem"}, xx);
    // endtask

    systolic_array #(
        .SYSTOLIC_ARRAY_ROWS(SYSTOLIC_ARRAY_ROWS),
        .SYSTOLIC_ARRAY_COLS(SYSTOLIC_ARRAY_COLS),
        .FIXED_POINT_WIDTH(FIXED_POINT_WIDTH)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_in = ~clk_in;

    initial begin
        $dumpfile("systolic_array.fst");
        $dumpvars(0, UUT);
        clk_in = 0;
        repeat(1) @(negedge clk_in);
        $finish;
    end

endmodule
