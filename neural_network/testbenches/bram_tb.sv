`timescale 1ns/1ps
`default_nettype none

module bram_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter ADDR_LEN = 5;
    parameter WORD_LEN = 32;
    parameter ROM_FILE = "zeros.mem";
    logic clk_i, reset_i;
    logic ena_i, wr_ena_i;
    logic [$clog2(ADDR_LEN)-1:0] addr_i;
    logic [WORD_LEN-1:0] data_i;
    wire [WORD_LEN-1:0] data_o;

    bram #(
        .ADDR_LEN(ADDR_LEN),
        .WORD_LEN(WORD_LEN),
        .ROM_FILE(ROM_FILE)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("bram.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;
        $finish;
    end

endmodule
