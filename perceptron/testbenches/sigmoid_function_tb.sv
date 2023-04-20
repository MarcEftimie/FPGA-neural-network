`timescale 1ns/1ps
`default_nettype none

module sigmoid_function_tb;

    parameter CLK_PERIOD_NS = 10;
    logic clk_i;
    logic en;
    logic we;
    logic reset_i;
    logic [9:0] addr;
    logic [15:0] di;
    wire [15:0] dout;
    integer i;
    sigmoid_function #(
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("sigmoid_function.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 0;
        we = 0;
        en = 1;
        repeat(1) @(negedge clk_i);
        for (i=0;i<=1023;i++) begin
            addr = i;
            repeat(1) @(negedge clk_i);
        end
        $finish;
    end

endmodule
