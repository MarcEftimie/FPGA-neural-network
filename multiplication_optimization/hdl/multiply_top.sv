`timescale 1ns/1ps
`default_nettype none

module multiply_top
    (
        input wire clk_i, reset_i,
        input wire [31:0] a_i, b_i,
        output logic [3:0] product_o
    );

    always_ff @(posedge clk_i) begin
        if (reset_i) begin
            
        end else begin
            
        end
    end

    assign product = a * b;

endmodule
