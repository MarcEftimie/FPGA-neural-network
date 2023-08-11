`timescale 1ns/1ps
`default_nettype none

module adder_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter ADDEND_WIDTH = 16;
    parameter SUM_WIDTH = ADDEND_WIDTH + 1;
    logic clk_in;
    logic [ADDEND_WIDTH-1:0] addend_1_in;
    logic [ADDEND_WIDTH-1:0] addend_2_in;
    wire [SUM_WIDTH-1:0] sum_out;
    logic [SUM_WIDTH-1:0] expected_sum_out;
    logic [SUM_WIDTH-1:0] edge_values [3:0];
    int i;
    int j;

    adder #(
        .ADDEND_WIDTH(ADDEND_WIDTH),
        .SUM_WIDTH(SUM_WIDTH)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_in = ~clk_in;

    initial begin
        $dumpfile("adder.fst");
        $dumpvars(0, UUT);
        clk_in = 0;

        edge_values[0] = 16'h0000; // lowest
        edge_values[1] = 16'hFFFF; // max 
        edge_values[2] = 16'h8000; // lowest signed
        edge_values[3] = 16'h7FFF; // max signed

        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                addend_1_in = edge_values[i];
                addend_2_in = edge_values[j];
                repeat(2) @(negedge clk_in);
                expected_sum_out = $signed(addend_1_in) + $signed(addend_2_in);
                if (sum_out !== expected_sum_out) begin
                    $display("Mismatch at multiplicand: %h multiplier: %h output: %h expected_out: %h", addend_1_in, addend_2_in, sum_out, expected_sum_out);
                end
            end
        end

        // Random testing
        for (i = 0; i < 1000; i = i + 1) begin
            addend_1_in = $random;
            addend_2_in = $random;
            repeat(2) @(negedge clk_in);
            expected_sum_out = $signed(addend_1_in) + $signed(addend_2_in);
            if (sum_out !== expected_sum_out) begin
                $display("Mismatch at multiplicand: %h multiplier: %h output: %h expected_out: %h", addend_1_in, addend_2_in, sum_out, expected_sum_out);
            end
        end
        $finish;
    end

endmodule
