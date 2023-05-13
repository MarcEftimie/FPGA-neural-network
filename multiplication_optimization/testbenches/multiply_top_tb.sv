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
        
        // Test case 1: 2.5 * 4 = 10
        a_i = 32'h40200000; // 2.5 in IEEE 754
        b_i = 32'h40800000; // 4 in IEEE 754
        repeat(3) @(negedge clk_i);
        $display("Expected: 32'h41200000, Got: %h", product_o);

        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;

        // Test case 2: -3 * 7 = -21
        a_i = 32'hC0400000; // -3 in IEEE 754
        b_i = 32'h40E00000; // 7 in IEEE 754
        repeat(3) @(negedge clk_i);
        $display("Expected: 32'hc1a80000, Got: %h", product_o);

        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;

        // Test case 3: 0 * 1 = 0
        a_i = 32'h00000000; // 0 in IEEE 754
        b_i = 32'h3f800000; // 1 in IEEE 754
        repeat(3) @(negedge clk_i);
        $display("Expected: 32'h00000000, Got: %h", product_o);

        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;

        // Test case 4: 1.5 * 1.5 = 2.25
        a_i = 32'h3fC00000; // 1.5 in IEEE 754
        b_i = 32'h3fC00000; // 1.5 in IEEE 754
        repeat(3) @(negedge clk_i);
        $display("Expected: 32'h40100000, Got: %h", product_o);

        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;

        // Test case 4: 1.5 * 1.5 = 2.25
        assign a_i = 32'h3f7fffff; // 1.9999998807907104 in IEEE 754
        assign b_i = 32'h3f7fffff; // 1.9999998807907104 in IEEE 754
        repeat(3) @(negedge clk_i);
        $display("Expected: 32'h3ffffffe, Got: %h", product_o);

        $finish;
    end
endmodule
