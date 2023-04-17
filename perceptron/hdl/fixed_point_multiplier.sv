`timescale 1ns/1ps
`default_nettype none

module fixed_point_multiplier
    #(
        parameter q_m = 17,
        parameter q_n = 16
    )
    (
        input wire clk_i, reset_i,
        input wire [(q_m+q_n)-1:0] a_in,
        input wire [(q_m+q_n)-1:0] b_in,
        output logic [(q_m+q_n)-1:0] y_out
    );

    logic [2*((q_m+q_n)-1):0] a_b_product;
    
    assign a_b_product = a_in[(q_m+q_n)-1:0] * b_in[(q_m+q_n)-1:0];
    assign y_out[(q_m+q_n)-2:0] = a_b_product >> q_n;
    assign y_out[(q_m+q_n)-1] = a_in[(q_m+q_n)-1] ^ b_in[(q_m+q_n)-1];

endmodule
