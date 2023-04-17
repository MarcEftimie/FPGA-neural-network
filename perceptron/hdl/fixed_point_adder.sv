`timescale 1ns/1ps
`default_nettype none

module fixed_point_adder
#(
    parameter sign = 1,
    parameter q_m = 16,
    parameter q_n = 15
)
(
    input wire [(sign + q_m + q_n) - 1:0] a_in,
    input wire [(sign + q_m + q_n) - 1:0] b_in,
    output logic [(sign + q_m + q_n) - 1:0] sum_out
);

    logic [(sign + q_m + q_n) - 2:0] a_mag, b_mag, sum_mag;
    logic a_sign, b_sign, sum_sign;
    
    assign a_sign = a_in[(sign + q_m + q_n) - 1];
    assign a_mag = a_in[(sign + q_m + q_n) - 2:0];
    assign b_sign = b_in[(sign + q_m + q_n) - 1];
    assign b_mag = b_in[(sign + q_m + q_n) - 2:0];

    always_comb begin
        if (a_sign == b_sign) begin
            sum_mag = a_mag + b_mag;
            sum_sign = a_sign;
        end else begin
            if (a_mag > b_mag) begin
                sum_mag = a_mag - b_mag;
                sum_sign = a_sign;
            end else if (a_mag < b_mag) begin
                sum_mag = b_mag - a_mag;
                sum_sign = b_sign;
            end else begin
                sum_mag = 31'b0;
                sum_sign = 1'b0;
            end
        end
    end

    assign sum_out = {sum_sign, sum_mag};

endmodule
