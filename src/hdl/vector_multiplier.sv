
`timescale 1ns/1ps
`default_nettype none

module vector_multiplier
    #(
        parameter VECTOR_LENGTH = 64,
        parameter FIXED_POINT_WIDTH = 16,
        parameter FIXED_POINT_POSITION = 10
    )
    (
        input wire clk_in,
        input wire [VECTOR_LENGTH-1:0][FIXED_POINT_WIDTH-1:0] vector_1_in,
        input wire [VECTOR_LENGTH-1:0][FIXED_POINT_WIDTH-1:0] vector_2_in,
        output logic [FIXED_POINT_WIDTH-1:0] product_out
    );

    localparam UNRECTIFIED_DATA_WIDTH = FIXED_POINT_WIDTH * 2;


// -----------------------------Define Signals---------------------------------
    logic [VECTOR_LENGTH-1:0][FIXED_POINT_WIDTH-1:0] intermediate_products;

// -----------------------------Assign Signals---------------------------------

    generate
        for (genvar i = 0; i < VECTOR_LENGTH; i = i + 1) begin : multipliers_loop
            signed_fixed_point_multiplier #(
                .FIXED_POINT_WIDTH(FIXED_POINT_WIDTH),
                .FIXED_POINT_POSITION(FIXED_POINT_POSITION)
            ) FIXED_POINT_MULTIPLIER_1 (
                .clk_in(clk_in),
                .multiplicand_in(vector_1_in[i]),
                .multiplier_in(vector_2_in[i]),
                .product_out(intermediate_products[i])
            );
        end
    endgenerate

    cascaded_adder_chain #(
        .ADDEND_WIDTH(FIXED_POINT_WIDTH),
        .NUMBER_OF_ADDENDS(64)
    ) CASCADED_ADDER_CHAIN (
        .clk_in(clk_in),
        .addends_in(intermediate_products),
        .sum_out(product_out)
    );

endmodule
