
`timescale 1ns/1ps
`default_nettype none

module row_selector_tb;

    parameter CLK_PERIOD_NS = 10;

    // UUT Parameters
    parameter SYSTOLIC_WIDTH = 2;
    parameter M1_WIDTH = 3;

    // UUT Inputs
    logic clk_in;
    logic rst_in;

    // UUT Outputs
    wire item_out;


    // Test Hyperparameters
    parameter TEST_COUNT = 1;
    string MEM_PATH = "./mem/test_vectors/row_selector/";

    // Test Vectors
    logic [1-1:0] xx [0:TEST_COUNT-1];

    // task automatic readMem();
    //    $readmemb({MEM_PATH, xx".mem"}, xx);
    // endtask

    row_selector #(
        .SYSTOLIC_WIDTH(SYSTOLIC_WIDTH),
        .M1_WIDTH(M1_WIDTH)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_in = ~clk_in;

    initial begin
        $dumpfile("row_selector.fst");
        $dumpvars(0, UUT);
        clk_in = 0;
        rst_in = 1;
        repeat(1) @(negedge clk_in);
        rst_in = 0;
        repeat(100) @(negedge clk_in);
        $finish;
    end

endmodule
