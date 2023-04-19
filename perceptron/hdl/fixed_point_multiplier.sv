`timescale 1ns/1ps
`default_nettype none

module fixed_point_multiplier
    #(
        parameter SIGN = 1,
        parameter Q_M = 15,
        parameter Q_N = 16
    )
    (
        input wire [(SIGN + Q_M + Q_N) - 1:0] a_in,
        input wire [(SIGN + Q_M + Q_N) - 1:0] b_in,
        output logic [(SIGN + Q_M + Q_N) - 1:0] y_out
    );

    logic [2*((SIGN + Q_M + Q_N) - 1):0] a_b_product;
    
    assign a_b_product = a_in[(SIGN + Q_M + Q_N) - 2:0] * b_in[(SIGN + Q_M + Q_N) - 2:0];
    assign y_out[(SIGN + Q_M + Q_N) - 2:0] = a_b_product >> Q_N;
    assign y_out[(SIGN + Q_M + Q_N) - 1] = a_in[(SIGN + Q_M + Q_N) - 1] ^ b_in[(SIGN + Q_M + Q_N) - 1];

endmodule
