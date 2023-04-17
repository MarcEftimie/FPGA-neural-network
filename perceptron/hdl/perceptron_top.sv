`timescale 1ns/1ps
`default_nettype none

module perceptron_top
    (
        input wire clk_i, reset_i
    );

    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
        
        end else begin
            
        end
    end

endmodule
