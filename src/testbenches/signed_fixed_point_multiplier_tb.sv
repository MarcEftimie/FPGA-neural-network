`timescale 1ns/1ps
`default_nettype none

module signed_fixed_point_multiplier_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter FIXED_POINT_LENGTH = 16;
    parameter FIXED_POINT_POSITION = 10;
    logic clk_in;
    logic signed [FIXED_POINT_LENGTH-1:0] multiplicand_in;
    logic signed [FIXED_POINT_LENGTH-1:0] multiplier_in;
    wire signed [FIXED_POINT_LENGTH-1:0] product_out;
    logic signed [FIXED_POINT_LENGTH*2-1:0] expected_product_out;
    logic signed [FIXED_POINT_LENGTH-1:0] edge_values [3:0];
    int i;
    int j;
    int DELAY = 7;

    localparam MAX_VALUE = (2**(FIXED_POINT_LENGTH-1)) - 1;
    localparam MIN_VALUE = -(2**(FIXED_POINT_LENGTH-1));

    signed_fixed_point_multiplier #(
        .FIXED_POINT_LENGTH(FIXED_POINT_LENGTH),
        .FIXED_POINT_POSITION(FIXED_POINT_POSITION)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_in = ~clk_in;

    initial begin
        $dumpfile("signed_fixed_point_multiplier.fst");
        $dumpvars(0, UUT);
        clk_in = 0;

        edge_values[0] = 16'h0000; // lowest
        edge_values[1] = 16'hFFFF; // max 
        edge_values[2] = 16'h8000; // lowest signed
        edge_values[3] = 16'h7FFF; // max signed

        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                multiplicand_in = edge_values[i];
                multiplier_in = edge_values[j];
                repeat(DELAY) @(negedge clk_in);
                if (($signed(multiplicand_in) * $signed(multiplier_in) >>> 10) > MAX_VALUE) begin
                    expected_product_out = MAX_VALUE;
                end else if (($signed(multiplicand_in) * $signed(multiplier_in) >>> 10) < MIN_VALUE) begin
                    expected_product_out = MIN_VALUE;
                end else begin
                    expected_product_out = $signed(multiplicand_in) * $signed(multiplier_in) >>> 10; 
                end
                if (product_out !== expected_product_out[FIXED_POINT_LENGTH-1:0]) begin
                    $display("Mismatch at multiplicand: %h multiplier: %h output: %h expected_out: %h", multiplicand_in, multiplier_in, product_out, expected_product_out);
                end
            end
        end

        // Random testing
        for (i = 0; i < 1000; i = i + 1) begin
            multiplicand_in = $random;
            multiplier_in = $random;
            repeat(DELAY) @(negedge clk_in);
            if (((multiplicand_in * multiplier_in) >>> 10) > MAX_VALUE) begin
                expected_product_out = MAX_VALUE;
            end else if (((multiplicand_in * multiplier_in) >>> 10) < MIN_VALUE) begin
                expected_product_out = MIN_VALUE;
            end else begin
                expected_product_out = (multiplicand_in * multiplier_in) >>> 10; 
            end
            if (product_out !== expected_product_out[FIXED_POINT_LENGTH-1:0]) begin
                $display("Mismatch at multiplicand: %d multiplier: %d output: %d expected_out: %d", multiplicand_in, multiplier_in, product_out, expected_product_out);
            end
        end

        // Constrained Random testing
        for (i = 0; i < 1000; i = i + 1) begin
            multiplicand_in = $urandom_range(0, 2**10);
            multiplier_in = $urandom_range(0, 2**10);
            repeat(DELAY) @(negedge clk_in);
            if (((multiplicand_in * multiplier_in) >>> 10) > MAX_VALUE) begin
                expected_product_out = MAX_VALUE;
            end else if (((multiplicand_in * multiplier_in) >>> 10) < MIN_VALUE) begin
                expected_product_out = MIN_VALUE;
            end else begin
                expected_product_out = (multiplicand_in * multiplier_in) >>> 10; 
            end
            if (product_out !== expected_product_out[FIXED_POINT_LENGTH-1:0]) begin
                $display("Mismatch at multiplicand: %d multiplier: %d output: %d expected_out: %d", multiplicand_in, multiplier_in, product_out, expected_product_out);
            end
        end
        $finish;
    end

endmodule
