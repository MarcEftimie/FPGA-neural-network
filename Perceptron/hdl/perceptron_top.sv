`timescale 1ns/1ps
`default_nettype none

module perceptron_top
    #(
        parameter HELLO = 1,
        parameter HELLO2 = 1
    ) (
        input wire [1:0] clk_i, reset_i, btn_i,
        output logic [1:0] out1, led1,
        inout tri sda
    );

endmodule
