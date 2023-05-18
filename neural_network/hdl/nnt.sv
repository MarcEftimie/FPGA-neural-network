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
        .rd_addr_1_i(rd_addr_1),
        .rd_addr_2_i(rd_addr_2),
        .wr_addr_i(wr_addr),
        .data_i(wr_data),
        .data_1_o(rd_data_1),
        .data_2_o(rd_data_2)
    );

    typedef enum logic [2:0] {
        IDLE,
        INIT_NEURON_COUNTS,
        CALCULATE_NEURON_OUTPUT,
        DONE
    } state_t;

    state_t state_reg, state_next;

    logic ena;
    
    logic wr_ena;
    logic [$clog2(ADDR_LEN)-1:0] rd_addr_1, rd_addr_2;
    logic [$clog2(ADDR_LEN)-1:0] wr_addr;
    logic [DATA_LEN-1:0] rd_data_1, rd_data_2;
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
            a_count_reg <= 0;
            b_count_reg <= 0;
            neuron_count_reg <= 0;
            sum_reg <= 0;
        end else begin
            state_reg <= state_next;
            neuron_output_reg <= neuron_output_next;
            neuron_weight_reg <= neuron_weight_next;
            count_reg <= count_next;
            init_reg <= init_next;
            prev_layer_neuron_count_reg <= prev_layer_neuron_count_next;
            curr_layer_neuron_count_reg <= curr_layer_neuron_count_next;
            layer_count_reg <= layer_count_next;
            a_count_reg <= a_count_next;
            b_count_reg <= b_count_next;
            neuron_count_reg <= neuron_count_next;
            sum_reg <= sum_next;
        end
    end

    logic [47:0] multiplier_output;

    logic [31:0] neuron_output_reg, neuron_output_next;
    logic [31:0] neuron_weight_reg, neuron_weight_next;

    logic [2:0] count_next, count_reg;

    logic init_reg, init_next;

    logic [31:0] prev_layer_neuron_count_reg, prev_layer_neuron_count_next;
    logic [31:0] curr_layer_neuron_count_reg, curr_layer_neuron_count_next;

    logic [$clog2(ADDR_LEN)-1:0] a_count_reg, a_count_next;
    logic [$clog2(ADDR_LEN)-1:0] b_count_reg, b_count_next;

    logic [15:0] layer_count_reg, layer_count_next;

    logic [15:0] neuron_count_reg, neuron_count_next;

    real sum_reg, sum_next;

    always_comb begin
        state_next = state_reg;
        rd_addr_1 = 0;
        rd_addr_2 = 0;
        wr_addr = 0;
        wr_data = 0;
        wr_ena = 0;
        ena = 1;

        neuron_output_next = neuron_output_reg;
        neuron_weight_next = neuron_weight_reg;
        count_next = count_reg;
        init_next = init_reg;

        prev_layer_neuron_count_next = prev_layer_neuron_count_reg;
        curr_layer_neuron_count_next = curr_layer_neuron_count_reg;

        a_count_next = a_count_reg;
        b_count_next = b_count_reg;

        neuron_count_next = neuron_count_reg;

        layer_count_next = layer_count_reg;

        multiplier_output = {1'b1, neuron_output_reg[22:0]} * {1'b1, neuron_weight_reg[22:0]};

        case (state_reg)
            IDLE : begin
                if (layer_count_reg < LAYER_COUNT-1) begin
                    layer_count_next = layer_count_reg + 1;
                    rd_addr_1 = layer_count_reg;
                    rd_addr_2 = layer_count_next;
                    state_next = INIT_NEURON_COUNTS;
                    if (layer_count_reg == 0) begin
                        a_count_next = LAYER_COUNT;
                    end
                end else begin
                    state_next = IDLE;
                end
            end
            INIT_NEURON_COUNTS : begin
                prev_layer_neuron_count_next = rd_data_1;
                curr_layer_neuron_count_next = rd_data_2;
                count_next = 0;
                init_next = 1;

                b_count_next = a_count_reg + rd_data_1;

                rd_addr_1 = a_count_reg;
                rd_addr_2 = b_count_next;

                neuron_count_next = 0;

                state_next = CALCULATE_NEURON_OUTPUT;
            end
            CALCULATE_NEURON_OUTPUT : begin
                case (count_reg)
                    0 : begin
                        neuron_output_next = rd_data_1;
                        neuron_weight_next = rd_data_2;

                        if (~init_reg) begin
                            wr_data[31] = neuron_weight_reg[31] ^ neuron_weight_reg[31];
                            if (multiplier_output[47]) begin
                                wr_data[30:23] = neuron_output_reg[30:23] + neuron_weight_reg[30:23] - 8'd127 + 1;
                                wr_data[22:0] = multiplier_output[46:24];
                            end else begin
                                wr_data[30:23] = neuron_output_reg[30:23] + neuron_weight_reg[30:23] - 8'd127;
                                wr_data[22:0] = multiplier_output[45:23];
                            end
                            // Cast bit vectors to shortreal
                            shortreal sum_reg;
                            assign a_real = $bitstoreal(a);

                            shortreal b_real;
                            assign b_real = $bitstoreal(b);

                            // Add and cast back to bit vector
                            shortreal sum_real;
                            assign sum_real = a_real + b_real;
                            assign sum = $realtobits(sum_real);
                            // wr_ena = 1;
                            // wr_addr = 100;
                        end
                        init_next = 0;
                        count_next = 1;
                    end
                    1 : begin
                        a_count_next = a_count_reg + 1;
                        b_count_next = b_count_reg + 1;

                        rd_addr_1 = a_count_next;
                        rd_addr_2 = b_count_next;

                        count_next = 0;
                        neuron_count_next = neuron_count_reg + 1;
                    end
                endcase
                if (neuron_count_reg < prev_layer_neuron_count_reg) begin
                    state_next = CALCULATE_NEURON_OUTPUT;
                end else begin
                    state_next = IDLE;
                end
                
            end
            default: begin
                state_next = IDLE;
            end
        endcase
    end

endmodule
