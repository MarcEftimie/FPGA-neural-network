`timescale 1ns/1ps
`default_nettype none

module neuron_trainer #(
        parameter LEARNING_RATE =    32'b0_000000000000001_0000000000000000,
        parameter INIT_WEIGHT_1 =    32'b0_000000000000001_0000000000000000,
        parameter INIT_WEIGHT_2 =    32'b0_000000000000001_0000000000000000,
        parameter INIT_WEIGHT_BIAS = 32'b0_000000000000000_0100000000000000,
        parameter BIAS =             32'b0_000000000000001_0000000000000000,
        parameter SIGN = 1,
        parameter Q_M = 15,
        parameter Q_N = 16
    ) (
        input wire clk_i, reset_i,
        input wire valid_i,
        input wire [(SIGN + Q_M + Q_N) - 1:0] train_x1_in, train_x2_in, train_out_in
    );

    neuron #(
        .BIAS(BIAS),
        .SIGN(SIGN),
        .Q_M(Q_M),
        .Q_N(Q_N)
    ) NEURON (
        .x1_in(train_x1_in),
        .x2_in(train_x2_in),
        .w1(weight_1_reg),
        .w2(weight_2_reg),
        .wb(weight_bias_reg),
        .out(prediction_out)
    );

    logic [(SIGN + Q_M + Q_N) - 1:0] lr_error_product;

    fixed_point_multiplier #(
        .SIGN(SIGN),
        .Q_M(Q_M),
        .Q_N(Q_N)
    ) ERROR_MULTIPLIER_1 (
        .a_in(learning_rate),
        .b_in(error),
        .y_out(lr_error_product)
    );

    logic [(SIGN + Q_M + Q_N) - 1:0] weight_1_addend;
    logic [(SIGN + Q_M + Q_N) - 1:0] weight_2_addend;
    logic [(SIGN + Q_M + Q_N) - 1:0] weight_bias_addend;

    fixed_point_multiplier #(
        .SIGN(SIGN),
        .Q_M(Q_M),
        .Q_N(Q_N)
    ) WEIGHT_MULTIPLIER_1 (
        .a_in(lr_error_product),
        .b_in(train_x1_in),
        .y_out(weight_1_addend)
    );

    fixed_point_multiplier #(
        .SIGN(SIGN),
        .Q_M(Q_M),
        .Q_N(Q_N)
    ) WEIGHT_MULTIPLIER_2 (
        .a_in(lr_error_product),
        .b_in(train_x2_in),
        .y_out(weight_2_addend)
    );

    fixed_point_multiplier #(
        .SIGN(SIGN),
        .Q_M(Q_M),
        .Q_N(Q_N)
    ) WEIGHT_MULTIPLIER_BIAS (
        .a_in(lr_error_product),
        .b_in(BIAS),
        .y_out(weight_bias_addend)
    );

    fixed_point_adder #(
        .SIGN(SIGN),
        .Q_M(Q_M),
        .Q_N(Q_N)
    ) ERROR_ADDER (
        .a_in(train_out_in),
        .b_in({~prediction_out[(SIGN + Q_M + Q_N) - 1], prediction_out[(SIGN + Q_M + Q_N) - 2:0]}),
        .sum_out(error)
    );

    fixed_point_adder #(
        .SIGN(SIGN),
        .Q_M(Q_M),
        .Q_N(Q_N)
    ) WEIGHT_ADDER_1 (
        .a_in(weight_1_reg),
        .b_in(weight_1_addend),
        .sum_out(weight_1_next)
    );

    fixed_point_adder #(
        .SIGN(SIGN),
        .Q_M(Q_M),
        .Q_N(Q_N)
    ) WEIGHT_ADDER_2 (
        .a_in(weight_2_reg),
        .b_in(weight_2_addend),
        .sum_out(weight_2_next)
    );

    fixed_point_adder #(
        .SIGN(SIGN),
        .Q_M(Q_M),
        .Q_N(Q_N)
    ) WEIGHT_ADDER_BIAS (
        .a_in(weight_bias_reg),
        .b_in(weight_bias_addend),
        .sum_out(weight_bias_next)
    );

    logic [(SIGN + Q_M + Q_N) - 1:0] learning_rate;
    assign learning_rate = LEARNING_RATE;

    logic [(SIGN + Q_M + Q_N) - 1:0] weight_1_reg, weight_1_next;
    logic [(SIGN + Q_M + Q_N) - 1:0] weight_2_reg, weight_2_next;
    logic [(SIGN + Q_M + Q_N) - 1:0] weight_bias_reg, weight_bias_next;

    logic [(SIGN + Q_M + Q_N) - 1:0] error;
    logic [(SIGN + Q_M + Q_N) - 1:0] prediction_out;

    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i || ~valid_i) begin
            weight_1_reg <= INIT_WEIGHT_1;
            weight_2_reg <= INIT_WEIGHT_2;
            weight_bias_reg <= INIT_WEIGHT_BIAS;
        end else begin
            weight_1_reg <= weight_1_next;
            weight_2_reg <= weight_2_next;
            weight_bias_reg <= weight_bias_next;
        end
    end

endmodule
