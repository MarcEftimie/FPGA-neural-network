`timescale 1ns/1ps
`default_nettype none

module neuron_trainer #(
        parameter TRAIN_ITERATIONS = 10,
        parameter LEARNING_RATE = 32'b0_000000000000001_0000000000000000,
        parameter INIT_WEIGHT_1 = 32'b0_000000000000001_0000000000000000,
        parameter INIT_WEIGHT_2 = 32'b0_000000000000001_0000000000000000,
        parameter INIT_WEIGHT_BIAS = 32'b0_000000000000001_0000000000000000,
        parameter SIGN = 1,
        parameter Q_M = 15,
        parameter Q_N = 16
    ) (
        input wire clk_i, reset_i,
        input wire [(SIGN + Q_M + Q_N) - 1:0] train_x1_in, train_x2_in, train_out_in,
        input wire valid_i
    );

    typedef enum logic [1:0] { 
        IDLE,
        TRAIN,
        DONE
    } state_t;

    state_t state_reg, state_next;

    logic [(SIGN + Q_M + Q_N) - 1:0] learning_rate;
    assign learning_rate = LEARNING_RATE;

    logic [(SIGN + Q_M + Q_N) - 1:0] weight_1_reg, weight_1_next;
    logic [(SIGN + Q_M + Q_N) - 1:0] weight_2_reg, weight_2_next;
    logic [(SIGN + Q_M + Q_N) - 1:0] weight_bias_reg, weight_bias_next;

    logic [(SIGN + Q_M + Q_N) - 1:0] error;
    logic [(SIGN + Q_M + Q_N) - 1:0] prediction_out;

    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            state_reg <= 0;
        end else begin
            state_reg <= state_next;
            weight_1_reg <= weight_1_next;
            weight_2_reg <= weight_2_next;
            weight_bias_reg <= weight_bias_next;
        end
    end

    always_comb begin
        state_next = state_reg;
        case(state_reg)
            IDLE : begin
                if (valid_i) begin
                    state_next = TRAIN;
                end
            end
            TRAIN : begin
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

                // error = prediction - prediction_out
                // weights = error * learning_rate * weights
                
            end
            DONE : begin
            
            end
            default : begin
                state_next = IDLE;
            end
        endcase
    end

endmodule
