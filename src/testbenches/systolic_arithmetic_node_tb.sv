`timescale 1ns/1ps
`default_nettype none

module systolic_arithmetic_node_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter FIXED_POINT_WIDTH = 16;
    parameter PARTIAL_SUM_WIDTH_IN = 16;
    parameter PARTIAL_SUM_WIDTH_OUT = PARTIAL_SUM_WIDTH_IN + 1;
    parameter FIXED_POINT_POSITION = 10;

    // UUT Inputs
    logic clk_in;
    logic weight_valid_in;
    logic signed [FIXED_POINT_WIDTH-1:0] weight_in;
    logic signed [FIXED_POINT_WIDTH-1:0] activation_in;
    logic signed [PARTIAL_SUM_WIDTH_IN-1:0] partial_sum_in;

    // UUT Outputs
    wire signed [FIXED_POINT_WIDTH-1:0] activation_out;
    wire signed [PARTIAL_SUM_WIDTH_OUT-1:0] partial_sum_out;

    // Test Hyperparameters
    parameter TEST_COUNT = 100000;
    string MEM_PATH = "./mem/test_vectors/systolic_artihmetic_node/";

    // Test Vectors
    logic signed [FIXED_POINT_WIDTH-1:0] weights_test_vector [0:TEST_COUNT-1];
    logic signed [FIXED_POINT_WIDTH-1:0] activations_test_vector [0:TEST_COUNT-1];
    logic signed [PARTIAL_SUM_WIDTH_IN-1:0] partial_sums_test_vector [0:TEST_COUNT-1];
    logic signed [PARTIAL_SUM_WIDTH_OUT-1:0] sums_test_vector [0:TEST_COUNT-1];

    task automatic readMem();
        $readmemb({MEM_PATH, "weights.mem"}, weights_test_vector);
        $readmemb({MEM_PATH, "activations.mem"}, activations_test_vector);
        $readmemb({MEM_PATH, "partial_sums.mem"}, partial_sums_test_vector);
        $readmemb({MEM_PATH, "sums.mem"}, sums_test_vector);
    endtask

    systolic_arithmetic_node #(
        .FIXED_POINT_WIDTH(FIXED_POINT_WIDTH),
        .PARTIAL_SUM_WIDTH_IN(PARTIAL_SUM_WIDTH_IN),
        .FIXED_POINT_POSITION(FIXED_POINT_POSITION)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_in = ~clk_in;

    int test_count;

    initial begin
        $dumpfile("systolic_arithmetic_node.fst");
        $dumpvars(0, UUT);
        clk_in = 0;
        readMem();
        repeat(1) @(negedge clk_in);
        for (test_count=0; test_count < TEST_COUNT; test_count++) begin
            weight_in = weights_test_vector[test_count];
            weight_valid_in = 1'b1;
            repeat(1) @(negedge clk_in);
            weight_in = 16'h0000;
            weight_valid_in = 1'b0;

            activation_in = activations_test_vector[test_count];
            partial_sum_in = partial_sums_test_vector[test_count];
            repeat(2) @(negedge clk_in);
            if (partial_sum_out !== sums_test_vector[test_count]) begin
                $display("ERROR CASE %d: WEIGHT: %d ACTIVATION: %d PARTIAL_SUM: %d SUM: %d EXPECTED_SUM: %d", test_count, weights_test_vector[test_count], activations_test_vector[test_count], partial_sums_test_vector[test_count], partial_sum_out, sums_test_vector[test_count]);
            end
            repeat(1) @(negedge clk_in);
        end
        
        // repeat(1) @(negedge clk_in);
        $finish;
    end

endmodule
