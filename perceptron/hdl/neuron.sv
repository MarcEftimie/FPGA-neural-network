`timescale 1ns/1ps
`default_nettype none

module neuron
    #(
        parameter BIAS = 1,
        parameter W1 = 1,
        parameter W2 = 1,
        parameter WB = 1,
        parameter sign = 1,
        parameter q_m = 16,
        parameter q_n = 16
    )
    (
        input wire x1_in, x2_in,
        output logic out
    );

    logic bias;
    assign bias = BIAS;

    logic [(sign + q_m + q_n) - 1:0] w1, w2, wb;
    assign w1 = W1;
    assign w2 = W2;
    assign wb = WB;

    logic [(sign + q_m + q_n) - 1:0] x1_addend, x2_addend, b_addend;

    logic [(sign + q_m + q_n) - 1:0] y_out;

    fixed_point_multiplier #(
        .sign(sign),
        .q_m(q_m),
        .q_n(q_n)
    ) MULTIPLIER_X1 (
        .a_in({{q_m{1'b0}}, x1_in, {q_n{1'b0}}}),
        .b_in(w1),
        .y_out(x1_addend)
    );

    fixed_point_multiplier #(
        .sign(sign),
        .q_m(q_m),
        .q_n(q_n)
    ) MULTIPLIER_X2 (
        .a_in({{q_m{1'b0}}, x2_in, {q_n{1'b0}}}),
        .b_in(w2),
        .y_out(x2_addend)
    );

    fixed_point_multiplier #(
        .sign(sign),
        .q_m(q_m),
        .q_n(q_n)
    ) MULTIPLIER_BIAS (
        .a_in({{q_m{1'b0}}, bias, {q_n{1'b0}}}),
        .b_in(wb),
        .y_out(b_addend)
    );

    fixed_point_adder #(
        .sign(sign),
        .q_m(q_m),
        .q_n(q_n)
    ) ADDER (
        .x1_in(x1_addend),
        .x2_in(x2_addend),
        .b_in(b_addend),
        .y_out(y_out)
    );

    activation_function #(
        .sign(sign),
        .q_m(q_m),
        .q_n(q_n)
    ) ACTIVATION_FUNCTION (
        .summation(y_out),
        .activation(out)
    );

endmodule
