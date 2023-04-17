`timescale 1ns/1ps
`default_nettype none

module float_multiplier
    (
        input wire clk_i, reset_i,
        input wire [31:0] a_in, b_in,
        output logic [31:0] y_out
    );
    
    assign y_out = a_in * b_in;

endmodule
