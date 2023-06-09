`timescale 1ns/1ps
`default_nettype none

module bram
    # (
        parameter ADDR_LEN = 5,
        parameter WORD_LEN = 32,
        parameter ROM_FILE = "zeros.mem"
    )
    (
        input wire clk_i,
        input wire ena_i, wr_ena_i,
        input wire [$clog2(ADDR_LEN)-1:0] rd_addr_1_i, rd_addr_2_i, wr_addr_i,
        input wire [WORD_LEN-1:0] data_i,
        output logic [WORD_LEN-1:0] data_1_o, data_2_o
    );

    logic [WORD_LEN-1:0] ram [ADDR_LEN-1:0];

    initial begin
        $readmemb({"./mem/", ROM_FILE}, ram);
    end
    
    always_ff @(posedge clk_i) begin
        data_1_o <= 0;
        data_2_o <= 0;
        if (ena_i) begin
            if (wr_ena_i) begin
                ram[wr_addr_i] <= data_i;
            end
            data_1_o <= ram[rd_addr_1_i];
            data_2_o <= ram[rd_addr_2_i];
        end
    end
    
endmodule
