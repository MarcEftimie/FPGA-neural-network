`timescale 1ns/1ps
`default_nettype none

module neuron_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter BIAS = 32'b0_000000000000001_0000000000000000;
    parameter SIGN = 1;
    parameter Q_M = 15;
    parameter Q_N = 16;
    logic clk_i;
    logic [(SIGN + Q_M + Q_N) - 1:0] x1_in, x2_in;
    logic [(SIGN + Q_M + Q_N) - 1:0] w1, w2, wb;
    wire [(SIGN + Q_M + Q_N) - 1:0] out;

    neuron #(
    .BIAS(BIAS),
    .SIGN(SIGN),
    .Q_M(Q_M),
    .Q_N(Q_N)
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
