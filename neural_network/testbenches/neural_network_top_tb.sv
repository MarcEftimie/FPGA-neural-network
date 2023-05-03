`timescale 1ns/1ps
`default_nettype none

module neural_network_top_tb;

    parameter CLK_PERIOD_NS = 10;
    logic clk_i, reset_i;

    neural_network_top #(
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("neural_network_top.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;
        $finish;
    end

endmodule
