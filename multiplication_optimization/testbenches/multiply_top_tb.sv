`timescale 1ns/1ps
`default_nettype none

module multiply_top_tb;

    parameter CLK_PERIOD_NS = 10;
    logic clk_i, reset_i;
    logic [31:0] a_i, b_i;
    wire [31:0] product_o;

    multiply_top #(
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("multiply_top.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;

        // Multiply 1 by 1
        a_i = 32'h3F800000; // 1
        b_i = 32'h3F800000; // 1
        repeat(3) @(negedge clk_i);
        assert(product_o == 32'h3F800000) else $error("Expected: 32'h3F800000, Got: %h", product_o);

        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;

        // Multiply two floats with 0 mantissa
        a_i = 32'h40400000; // 3
        b_i = 32'h40800000; // 4
        repeat(3) @(negedge clk_i);
        assert(product_o == 32'h41400000) else $error("Expected: 32'h41400000, Got: %h", product_o);

        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;

        // Multiply two floats with decimal values greater than 1
        a_i = 32'h40b00000; // 5.5
        b_i = 32'h40f00000; // 7.5
        repeat(3) @(negedge clk_i);
        assert(product_o == 32'h42250000) else $error("Expected: 32'h42250000, Got: %h", product_o);

        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;

        // Multiply two floats with decimal values
        a_i = 32'h40b00000; // 5.5
        b_i = 32'h3f400000; // 0.75
        repeat(3) @(negedge clk_i);
        assert(product_o == 32'h40840000) else $error("Expected: 32'h40840000, Got: %h", product_o);

        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;

        // Multiply two floats with decimal values
        a_i = 32'h3f000000; // 0.5
        b_i = 32'h3f400000; // 0.75
        repeat(3) @(negedge clk_i);
        assert(product_o == 32'h3ec00000) else $error("Expected: 32'h3ec00000, Got: %h", product_o);

        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;

        // Multiply two floats with repeating binary representations
        a_i = 32'h3de7a0f9; // 0.1131
        b_i = 32'h3f400000; // 0.75
        repeat(3) @(negedge clk_i);
        assert(product_o == 32'h3dadb8ba) else $error("Expected: 32'h3dadb8ba, Got: %h", product_o);

        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;

        // Multiply two floats that increases overflows the mantissa
        a_i = 32'h3f733333; // 0.95
        b_i = 32'h3f733333; // 0.95
        repeat(3) @(negedge clk_i);
        assert(product_o == 32'h3f670a3d) else $error("Expected: 32'h3f670a3d, Got: %h", product_o);

        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;

        $finish;
    end
endmodule
