`timescale 1ns/1ps
`default_nettype none

module trainer_top #(
        parameter TRAIN_ITERATIONS = 5,
        parameter LEARNING_RATE =    32'b0_000000000000001_0000000000000000,
        parameter INIT_WEIGHT_1 =    32'b0_000000000000001_0000000000000000,
        parameter INIT_WEIGHT_2 =    32'b0_000000000000001_0000000000000000,
        parameter INIT_WEIGHT_BIAS = 32'b0_000000000000000_0100000000000000,
        parameter BIAS =             32'b0_000000000000001_0000000000000000,
        parameter SIGN = 1,
        parameter Q_M = 15,
        parameter Q_N = 16
    ) (
        input wire clk_i, reset_i
    );

    neuron_trainer #(
        .LEARNING_RATE(LEARNING_RATE),
        .INIT_WEIGHT_1(INIT_WEIGHT_1),
        .INIT_WEIGHT_2(INIT_WEIGHT_2),
        .INIT_WEIGHT_BIAS(INIT_WEIGHT_BIAS),
        .BIAS(BIAS),
        .SIGN(SIGN),
        .Q_M(Q_M),
        .Q_N(Q_N)
    ) NEURON_TRAINER (
        .clk_i(clk_i),
        .valid_i(valid),
        .reset_i(reset_i),
        .train_x1_in(train_x1),
        .train_x2_in(train_x2),
        .train_out_in(train_out)
    );

    typedef enum logic [2:0] {
        IDLE,
        TRAIN_1,
        TRAIN_2,
        TRAIN_3,
        TRAIN_4,
        DONE
    } state_t;

    state_t state_reg, state_next;

    logic [(SIGN + Q_M + Q_N) - 1:0] train_x1, train_x2, train_out;

    logic [$clog2(TRAIN_ITERATIONS) - 1:0] iteration_count_reg, iteration_count_next;

    logic valid;

    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            state_reg = IDLE;
            iteration_count_reg = TRAIN_ITERATIONS;
        end else begin
            state_reg = state_next;
            iteration_count_reg = iteration_count_next;
        end
    end
    
    always_comb begin
        iteration_count_next = iteration_count_reg;
        state_next = state_reg;
        valid = 1;
        case(state_reg)
            IDLE : begin
                valid = 0;
                train_x1 =  32'b0_000000000000000_0000000000000000;
                train_x2 =  32'b0_000000000000000_0000000000000000;
                train_out = 32'b0_000000000000000_0000000000000000;
                state_next = TRAIN_1;
            end
            TRAIN_1 : begin
                train_x1 =  32'b0_000000000000001_0000000000000000;
                train_x2 =  32'b0_000000000000001_0000000000000000;
                train_out = 32'b0_000000000000001_0000000000000000;
                state_next = TRAIN_2;
            end
            TRAIN_2 : begin
                train_x1 =  32'b0_000000000000001_0000000000000000;
                train_x2 =  32'b0_000000000000000_0000000000000000;
                train_out = 32'b0_000000000000001_0000000000000000;
                state_next = TRAIN_3;
            end
            TRAIN_3 : begin
                train_x1 =  32'b0_000000000000000_0000000000000000;
                train_x2 =  32'b0_000000000000001_0000000000000000;
                train_out = 32'b0_000000000000001_0000000000000000;
                state_next = TRAIN_4;
            end
            TRAIN_4 : begin
                train_x1 =  32'b0_000000000000000_0000000000000000;
                train_x2 =  32'b0_000000000000000_0000000000000000;
                train_out = 32'b0_000000000000000_0000000000000000;
                if (iteration_count_reg > 0) begin
                    iteration_count_next = iteration_count_reg - 1;
                    state_next = TRAIN_1;
                end else begin
                    state_next = DONE;
                end
            end
            DONE : begin
                state_next = DONE;
            end
            default : begin
                state_next = IDLE;
            end
        endcase
    end

endmodule
