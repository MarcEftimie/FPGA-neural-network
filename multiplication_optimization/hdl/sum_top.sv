`timescale 1ns/1ps
`default_nettype none

module sum_top #(parameter WIDTH = 32)
(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    output wire [WIDTH-1:0] sum
);

    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = {1'b1, a[22:0]};
    wire [22:0] b_frac = {1'b1, b[22:0]};
    logic [23:0] sum_frac;
    logic [23:0] sum_frac_tmp;
    logic [7:0] sum_exp;
    logic [7:0] sum_exp_tmp;
    logic sum_sign;

    always_comb begin
        // Sign
        sum_sign = a_sign ^ b_sign;
        
        // Add mantissas
        sum_frac_tmp = a_exp > b_exp ? a_frac + ({1'b1, b_frac} >> (a_exp - b_exp)) :
                   b_exp > a_exp ? b_frac + ({1'b1, a_frac} >> (a_exp - b_exp)) : a_frac + b_frac;
        sum_exp_tmp = a_exp > b_exp ? a_exp :
                  b_exp > a_exp ? b_exp : a_exp + 1'b1;

        // Normalize the sum
        if (sum_frac_tmp[23] == 1'b1) begin
            sum_frac = sum_frac_tmp >> 1;
            sum_exp = sum_exp_tmp + 1'b1;
        end else begin
            sum_frac = sum_frac_tmp;
            sum_exp = sum_exp_tmp;
        end
    end
    assign sum = {sum_sign, sum_exp, sum_frac[22:0]};

endmodule
