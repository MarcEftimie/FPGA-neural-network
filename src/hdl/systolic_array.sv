`timescale 1ns/1ps
`default_nettype none

module systolic_array
    #(
        parameter SYSTOLIC_ARRAY_ROWS = 8,
        parameter SYSTOLIC_ARRAY_COLS = 8,
        parameter FIXED_POINT_WIDTH = 16
    )
    (
        input wire clk_in,
        input wire weights_valid_in,
        input wire [SYSTOLIC_ARRAY_ROWS-1:0][SYSTOLIC_ARRAY_COLS-1:0][FIXED_POINT_WIDTH-1:0] weights_in,
        input wire [SYSTOLIC_ARRAY_ROWS-1:0][FIXED_POINT_WIDTH-1:0] activations_in,
        output logic [SYSTOLIC_ARRAY_COLS-1:0][FIXED_POINT_WIDTH-1:0] sum_out
    );

// -----------------------------Define Signals---------------------------------
    logic [SYSTOLIC_ARRAY_ROWS-1:0][SYSTOLIC_ARRAY_COLS:0][FIXED_POINT_WIDTH-1:0] activation_connections;
    logic [SYSTOLIC_ARRAY_COLS-1:0][SYSTOLIC_ARRAY_ROWS:0][FIXED_POINT_WIDTH+6:0] partial_sum_connections;

// -----------------------------Assign Signals---------------------------------

    generate
        for (genvar row = 0; row < SYSTOLIC_ARRAY_ROWS; row++) begin
            assign activation_connections[row][0] = activations_in[row];
        end
    endgenerate
    
    generate
        
        for (genvar row = 0; row < SYSTOLIC_ARRAY_ROWS; row++) begin
            for (genvar col = 0; col < SYSTOLIC_ARRAY_COLS; col++) begin
                systolic_arithmetic_node #(
                    .FIXED_POINT_WIDTH(FIXED_POINT_WIDTH),
                    .FIXED_POINT_POSITION(10),
                    .PARTIAL_SUM_WIDTH_IN(FIXED_POINT_WIDTH + row)
                ) SYSTOLIC_ARITHMETIC_NODE (
                    .clk_in(clk_in),
                    .weight_valid_in(weights_valid_in),
                    .weight_in(weights_in[row][col]),
                    .activation_in(activation_connections[row][col]),
                    .partial_sum_in(partial_sum_connections[col][row]),
                    .activation_out(activation_connections[row][col+1]),
                    .partial_sum_out(partial_sum_connections[col][row+1])
                );
            end
        end
    endgenerate

    generate
        for (genvar col = 0; col < SYSTOLIC_ARRAY_COLS; col++) begin
            assign partial_sum_connections[col][0] = 0;
        end
    endgenerate

    generate
        for (genvar col = 0; col < SYSTOLIC_ARRAY_COLS; col++) begin
            assign sum_out[col] = partial_sum_connections[col][SYSTOLIC_ARRAY_ROWS];
        end
    endgenerate
    

// ----------------------------Register Signals--------------------------------

    always_ff @(posedge clk_in) begin : REGISTER_INPUT_SIGNALS
    end

    always_ff @(posedge clk_in) begin : REGISTER_OUTPUT_SIGNALS
    end

    always_ff @(posedge clk_in) begin : REGISTER_DESIGN_SIGNALS
    end

endmodule
