`timescale 1ns/1ps
`default_nettype none

module float_adder
#(
    parameter sign = 1,
    parameter q_m = 16,
    parameter q_n = 16
)
(
    input wire signed [sign + q_m + q_n - 1:0] a_in, b_in,
    output logic [sign + q_m + q_n - 1:0] y_out
);

    assign y_out = a_in + b_in;
    

endmodule
