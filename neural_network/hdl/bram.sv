`timescale 1ns/1ps
`default_nettype none

module bram
    # (
        parameter ADDR_LEN = 8,
        parameter WORD_LEN = 8
    )
    (
        input wire clk_i, reset_i,
        input wire ena_i, wr_ena_i,
        input wire [ADDR_LEN-1:0] addr_i,
        input wire [WORD_LEN-1:0] data_i,
        output logic [WORD_LEN-1:0] data_o
    );

    logic [WORD_LEN-1:0] ram [ADDR_LEN-1:0];
    
    always_ff @(posedge clk_i, posedge reset_i) begin
        data_o = 0;
        if (ena_i) begin
            if (wr_ena_i) begin
                ram[addr_i] = data_i;
            end
            data_o = ram[addr_i];
        end
    end
    
endmodule
