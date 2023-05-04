`timescale 1ns/1ps
`default_nettype none

module neural_network_top
    #(
        parameter ADDR_LEN = 2,
        parameter DATA_LEN = 16
    ) (
        input wire clk_i, reset_i
    );

    bram #(
        .ADDR_LEN(2),
        .WORD_LEN(16),
        .ROM_FILE("topology.mem")
    ) TOPOLOGY (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .ena_i(topology_ena_reg),
        .wr_ena_i(wr_ena_reg),
        .addr_i(addr_reg),
        .data_i(wr_data_reg),
        .data_o(rd_data)
    );

    typedef enum logic [1:0] {
        IDLE,
        GENERATE_TOPOLOGY
    } state_t;

    state_t state_reg, state_next;

    logic topology_ena_reg, topology_ena_next;
    
    logic wr_ena_reg, wr_ena_next;
    logic [ADDR_LEN-1:0] addr_reg, addr_next;
    logic [DATA_LEN-1:0] wr_data_reg, wr_data_next;
    logic [DATA_LEN-1:0] rd_data;

    logic [ADDR_LEN-1:0] addr_counter_reg, addr_counter_next;

    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            state_reg = IDLE;
            topology_ena_reg = 0;
            addr_reg = 0;
            wr_data_reg = 0;
        end else begin
            state_reg = state_next;
            topology_ena_reg = topology_ena_next;
            addr_reg = addr_next;
            wr_data_reg = wr_data_next;
        end
    end

    always_comb begin
        state_next = state_reg;
        topology_ena_next = topology_ena_reg;
        addr_next = addr_reg;
        wr_data_next = wr_data_reg;

        case (state_reg)
            IDLE : begin
                state_next = GENERATE_TOPOLOGY;
                topology_ena_next = 1;
                addr_next = 0;
            end
            GENERATE_TOPOLOGY : begin
                addr_next = addr_reg + 1;
                
            end
            default: begin
                state_next = IDLE;
            end
        endcase
    end
    

endmodule
