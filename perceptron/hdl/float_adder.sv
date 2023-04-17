`timescale 1ns/1ps
`default_nettype none

module float_adder
#(
    parameter q_m = 17,
    parameter q_n = 16
)
(
    input wire clk_i,
    input wire signed [q_m + q_n - 1:0] a_in, b_in,
    output logic [q_m + q_n - 1:0] y_out
);

    assign y_out = a_in + b_in;
    

endmodule
