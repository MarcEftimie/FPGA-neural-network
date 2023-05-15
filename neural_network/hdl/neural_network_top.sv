`timescale 1ns/1ps
`default_nettype none

module neural_network_top
    #(
        // Hyperparameters
        parameter EPOCH_COUNT = 5,
        parameter INPUT_COUNT = 3,
        parameter OUTPUT_COUNT = 1,
        parameter NETWORK_ADDR_LEN = 5,
        parameter NETWORK_DATA_LEN = 32,
        parameter TRAINER_ADDR_LEN = 4,
        parameter TRAINER_DATA_LEN = 32
    ) (
        input wire clk_i, reset_i
    );

    bram #(
        .ADDR_LEN(NETWORK_ADDR_LEN),
        .WORD_LEN(NETWORK_DATA_LEN),
        .ROM_FILE("network.mem")
    ) NETWORK_RAM (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .ena_i(network_ena_reg),
        .wr_ena_i(wr_ena_reg),
        .addr_i(addr_reg),
        .data_i(wr_data_reg),
        .data_o(rd_data)
    );

    bram #(
        .ADDR_LEN(TRAINER_ADDR_LEN),
        .WORD_LEN(TRAINER_DATA_LEN),
        .ROM_FILE("trainer.mem")
    ) TRAINER_RAM (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .ena_i(trainer_ena_reg),
        .wr_ena_i(wr_ena_reg),
        .addr_i(addr_reg),
        .data_i(wr_data_reg),
        .data_o(rd_data)
    );

    typedef enum logic [2:0] {
        IDLE,
        TRAINING_LOOP,
        INIT_FORWARD_PROPAGATION,
        FORWARD_PROPAGATION,
        INIT_BACK_PROPAGATION,
        BACK_PROPAGATION,
        DONE
    } state_t;

    state_t state_reg, state_next;

    logic network_ena_reg, network_ena_next;
    logic trainer_ena_reg, trainer_ena_next;
    
    logic wr_ena_reg, wr_ena_next;
    logic [ADDR_LEN-1:0] addr_reg, addr_next;
    logic [DATA_LEN-1:0] wr_data_reg, wr_data_next;
    logic [DATA_LEN-1:0] rd_data;

    logic [ADDR_LEN-1:0] addr_counter_reg, addr_counter_next;

    logic [$clog2(EPOCH_COUNT)-1:0] epoch_count_reg, epoch_count_next;

    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            clk_1 <= 0;
            state_reg <= IDLE;
            network_ena_reg <= 0;
            trainer_ena_reg <= 0;
            addr_reg <= 0;
            wr_data_reg <= 0;
            epoch_count_reg <= 0;
        end else begin
            clk_1 <= ~clk_1;
            state_reg <= state_next;
            network_ena_reg <= network_ena_next;
            trainer_ena_reg <= trainer_ena_next;
            addr_reg <= addr_next;
            wr_data_reg <= wr_data_next;
            epoch_count_reg <= epoch_count_next;
        end
    end

    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            neuron_output_reg = 0;
            neuron_weight_reg = 0;
            counter_reg = 0;
        end else begin
            neuron_output_reg = neuron_output_next;
            neuron_weight_reg = neuron_weight_next;
            counter_reg = counter_next;
        end
    end

    logic [31:0] neuron_output_reg, neuron_output_next;
    logic [31:0] neuron_weight_reg, neuron_weight_next;

    logic [2:0] counter_next, counter_reg;

    always_comb begin
        state_next = state_reg;
        topology_ena_next = topology_ena_reg;
        addr_next = addr_reg;
        wr_data_next = wr_data_reg;

        network_ena_next = 0;
        trainer_ena_next = 0;

        epoch_count_next = epoch_count_reg;

        neuron_output_next = neuron_output_reg;
        neuron_weight_next = neuron_weight_reg;
        counter_next = counter_reg;

        multiplier_ena = 0;

        case (state_reg)
            IDLE : begin
                state_next = TRAINING_LOOP;
            end
            CALCULATE_NEURON_OUTPUT : begin
                // init count = 0;
                case (count)
                    0 : begin
                        rd_address = 0; // get neuron output
                    end
                    1 : begin
                        rd_address = 1; // get neuron weight
                        neuron_output_next = rd_data;
                        multiplier_ena = 1;
                    end
                    2 : begin
                        neuron_weight_next = rd_data;
                    end
                endcase
                counter_next = counter_reg + 1;
                // s1 - rd o
                // s2 - rd w
            end
            default: begin
                state_next = IDLE;
            end
        endcase
    end

    logic multiplier_ena;
    logic [47:0] multiplier_output;

    always_ff @(posedge multiplier_ena) begin
        multiplier_output <= {1'b1, neuron_output_reg[22:0]} * {1'b1, neuron_weight_reg[22:0]};
    end
    

endmodule
