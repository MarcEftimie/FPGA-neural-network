`timescale 1ns/1ps
`default_nettype none

module nnt
    #(
        parameter ADDR_LEN = 2**16,
        parameter DATA_LEN = 32,
        parameter LAYER_COUNT = 2
    )
    (
        input wire clk_i, reset_i
    );

    bram #(
        .ADDR_LEN(ADDR_LEN),
        .WORD_LEN(DATA_LEN),
        .ROM_FILE("network.mem")
    ) NETWORK_RAM (
        .clk_i(clk_i),
        .ena_i(ena),
        .wr_ena_i(wr_ena),
        .rd_addr_i(rd_addr),
        .wr_addr_i(wr_addr),
        .data_i(wr_data),
        .data_o(rd_data)
    );

    typedef enum logic [2:0] {
        IDLE,
        INIT_PREV_LAYER_COUNT,
        INIT_CURRENT_LAYER_COUNT,
        CALCULATE_NEURON_OUTPUT,
        DONE
    } state_t;

    state_t state_reg, state_next;

    logic ena;
    
    logic wr_ena;
    logic [$clog2(ADDR_LEN)-1:0] rd_addr;
    logic [$clog2(ADDR_LEN)-1:0] wr_addr;
    logic [DATA_LEN-1:0] rd_data;
    logic [DATA_LEN-1:0] wr_data;

    always_ff @(posedge clk_i) begin
        if (reset_i) begin
            state_reg <= IDLE;
            neuron_output_reg <= 0;
            neuron_weight_reg <= 0;
            count_reg <= 0;
            init_reg <= 0;
            prev_layer_neuron_count_reg <= 0;
            curr_layer_neuron_count_reg <= 0;
            layer_count_reg <= 0;
        end else begin
            state_reg <= state_next;
            neuron_output_reg <= neuron_output_next;
            neuron_weight_reg = neuron_weight_next;
            count_reg <= count_next;
            init_reg <= init_next;
            prev_layer_neuron_count_reg <= prev_layer_neuron_count_next;
            curr_layer_neuron_count_reg <= curr_layer_neuron_count_next;
            layer_count_reg <= layer_count_next;
        end
    end

    logic [31:0] neuron_output_reg, neuron_output_next;
    logic [31:0] neuron_weight_reg, neuron_weight_next;

    logic [2:0] count_next, count_reg;

    logic init_reg, init_next;

    logic [31:0] prev_layer_neuron_count_reg, prev_layer_neuron_count_next;
    logic [31:0] curr_layer_neuron_count_reg, curr_layer_neuron_count_next;
    logic [15:0] layer_count_reg, layer_count_next;

    always_comb begin
        state_next = state_reg;
        rd_addr = 0;
        wr_addr = 0;
        wr_data = 0;
        wr_ena = 0;
        ena = 1;

        neuron_output_next = neuron_output_reg;
        neuron_weight_next = neuron_weight_reg;
        count_next = count_reg;
        init_next = init_reg;

        multiplier_ena = 0;

        prev_layer_neuron_count_next = prev_layer_neuron_count_reg;
        curr_layer_neuron_count_next = curr_layer_neuron_count_reg;
        layer_count_next = layer_count_reg;

        case (state_reg)
            IDLE : begin
                if (layer_count_reg < LAYER_COUNT-1) begin
                    rd_addr = layer_count_reg;
                    layer_count_next = layer_count_reg + 1;
                    state_next = INIT_PREV_LAYER_COUNT;
                end
                state_next = IDLE;
            end
            INIT_PREV_LAYER_COUNT : begin
                rd_addr = layer_count_reg;
                prev_layer_neuron_count_next = rd_data;
                state_next = INIT_CURRENT_LAYER_COUNT;
            end
            INIT_CURRENT_LAYER_COUNT : begin
                curr_layer_neuron_count_next = rd_data;
                init_next = 1;
                state_next = CALCULATE_NEURON_OUTPUT;
            end
            CALCULATE_NEURON_OUTPUT : begin
                case (count_reg)
                    0 : begin
                        rd_addr = 0;
                        count_next = 1;
                    end
                    1 : begin
                        rd_addr = 1;
                        neuron_output_next = rd_data;
                        count_next = 2;

                        if (~init_reg) begin
                            // Normalize float output
                            multiplier_ena = 1;
                            wr_data[31] = neuron_weight_reg[31] ^ neuron_weight_reg[31];
                            if (multiplier_output[47]) begin
                                wr_data[30:23] = neuron_output_reg[30:23] + neuron_weight_reg[30:23] - 8'd127 + 1;
                                wr_data[22:0] = multiplier_output[46:24];
                            end else begin
                                wr_data[30:23] = neuron_output_reg[30:23] + neuron_weight_reg[30:23] - 8'd127;
                                wr_data[22:0] = multiplier_output[45:23];
                            end
                            wr_ena = 1;
                            wr_addr = 0;
                        end
                        init_next = 0;
                    end
                    2 : begin
                        neuron_weight_next = rd_data;
                        count_next = 0;
                    end
                endcase
                state_next = CALCULATE_NEURON_OUTPUT;
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
