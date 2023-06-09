`timescale 1ns/1ps
`default_nettype none

module neuron
    #(
        parameter BIAS = 32'b0_000000000000001_0000000000000000,
        parameter SIGN = 1,
        parameter Q_M = 15,
        parameter Q_N = 16
    )
    (
        input wire [(SIGN + Q_M + Q_N) - 1:0] x1_in, x2_in,
        input wire [(SIGN + Q_M + Q_N) - 1:0] w1, w2, wb,
        output logic [(SIGN + Q_M + Q_N) - 1:0] out
    );

    logic [(SIGN + Q_M + Q_N) - 1:0] x1_addend, x2_addend, b_addend;

    logic [(SIGN + Q_M + Q_N) - 1:0] summation_1;
    logic [(SIGN + Q_M + Q_N) - 1:0] summation_2;

    fixed_point_multiplier #(
        .SIGN(SIGN),
        .Q_M(Q_M),
        .Q_N(Q_N)
    ) MULTIPLIER_X1 (
        .a_in(x1_in),
        .b_in(w1),
        .y_out(x1_addend)
    );

    fixed_point_multiplier #(
        .SIGN(SIGN),
        .Q_M(Q_M),
        .Q_N(Q_N)
    ) MULTIPLIER_X2 (
        .a_in(x2_in),
        .b_in(w2),
        .y_out(x2_addend)
    );

    fixed_point_multiplier #(
        .SIGN(SIGN),
        .Q_M(Q_M),
        .Q_N(Q_N)
    ) MULTIPLIER_BIAS (
        .a_in(BIAS),
        .b_in(wb),
        .y_out(b_addend)
    );

    fixed_point_adder #(
        .SIGN(SIGN),
        .Q_M(Q_M),
        .Q_N(Q_N)
    ) ADDER1 (
        .a_in(x1_addend),
        .b_in(x2_addend),
        .sum_out(summation_1)
    );

    fixed_point_adder #(
        .SIGN(SIGN),
        .Q_M(Q_M),
        .Q_N(Q_N)
    ) ADDER2 (
        .a_in(summation_1),
        .b_in(b_addend),
        .sum_out(summation_2)
    );

    activation_function #(
        .SIGN(SIGN),
        .Q_M(Q_M),
        .Q_N(Q_N)
    ) ACTIVATION_FUNCTION (
        .summation(summation_2),
        .activation(out)
    );

endmodule
