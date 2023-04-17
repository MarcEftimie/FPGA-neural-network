`timescale 1ns/1ps
`default_nettype none

module fixed_point_multiplier
    #(
        parameter sign = 1,
        parameter q_m = 16,
        parameter q_n = 16
    )
    (
        input wire clk_i, reset_i,
        input wire [(sign+q_m+q_n)-1:0] a_in,
        input wire [(sign+q_m+q_n)-1:0] b_in,
        output logic [(sign+q_m+q_n)-1:0] y_out
    );

    logic [2*((sign+q_m+q_n)-1):0] a_b_product;
    
    assign a_b_product = a_in[(sign+q_m+q_n)-2:0] * b_in[(sign+q_m+q_n)-2:0];
    assign y_out[(sign+q_m+q_n)-2:0] = a_b_product >> q_n;
    assign y_out[(sign+q_m+q_n)-1] = a_in[(sign+q_m+q_n)-1] ^ b_in[(sign+q_m+q_n)-1];

endmodule
