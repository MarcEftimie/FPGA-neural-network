`timescale 1ns/1ps
`default_nettype none

module neuron_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter BIAS = 1;
    parameter W1 = 32'b0_000000000000000_1100011101101111;
    parameter W2 = 32'b0_000000000000000_1011001000111111;
    parameter WB = 32'b1_000000000000000_0101001101100011;
    parameter sign = 1;
    parameter q_m = 15;
    parameter q_n = 16;
    logic clk_i;
    logic x1_in, x2_in;
    wire out;

    neuron #(
    .BIAS(BIAS),
    .W1(W1),
    .W2(W2),
    .WB(WB),
    .sign(sign),
    .q_m(q_m),
    .q_n(q_n)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("neuron.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        repeat(1) @(negedge clk_i);
        x1_in = 0;
        x2_in = 0;
        repeat(1) @(negedge clk_i);
        assert(out == 0);

        x1_in = 0;
        x2_in = 1;
        repeat(1) @(negedge clk_i);
        assert(out == 1);
        
        x1_in = 1;
        x2_in = 0;
        repeat(1) @(negedge clk_i);
        assert(out == 1);

        x1_in = 1;
        x2_in = 1;
        assert(out == 1);
        repeat(1) @(negedge clk_i);

        $finish;
    end

endmodule
