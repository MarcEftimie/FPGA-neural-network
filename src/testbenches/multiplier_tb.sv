`timescale 1ns/1ps
`default_nettype none

module multiplier_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter FACTOR_WIDTH = 16;
    parameter PRODUCT_WIDTH = FACTOR_WIDTH * 2;
    parameter FIXED_POINT_POSITION = 10;
    logic clk_in;
    logic [FACTOR_WIDTH-1:0] multiplicand_in;
    logic [FACTOR_WIDTH-1:0] multiplier_in;
    wire [PRODUCT_WIDTH-1:0] product_out;
    logic [PRODUCT_WIDTH-1:0] expected_product_out;
    logic [PRODUCT_WIDTH-1:0] edge_values [3:0];
    int i;
    int j;

    multiplier #(
        .FACTOR_WIDTH(FACTOR_WIDTH),
        .PRODUCT_WIDTH(PRODUCT_WIDTH),
        .FIXED_POINT_POSITION(FIXED_POINT_POSITION)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_in = ~clk_in;

    initial begin
        $dumpfile("multiplier.fst");
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
                repeat(3) @(negedge clk_in);
                expected_product_out = ($signed(multiplicand_in) * $signed(multiplier_in)) >>> 10;
                if (product_out !== expected_product_out) begin
                    $display("Mismatch at multiplicand: %h multiplier: %h output: %h expected_out: %h", multiplicand_in, multiplier_in, product_out, expected_product_out);
                end
            end
        end

        // Random testing
        for (i = 0; i < 1000; i = i + 1) begin
            multiplicand_in = $random;
            multiplier_in = $random;
            repeat(3) @(negedge clk_in);
            expected_product_out = ($signed(multiplicand_in) * $signed(multiplier_in)) >>> 10;
            if (product_out !== expected_product_out) begin
                $display("Mismatch at multiplicand: %h multiplier: %h output: %h expected_out: %h", multiplicand_in, multiplier_in, product_out, expected_product_out);
            end
        end

        $finish;
    end



endmodule
