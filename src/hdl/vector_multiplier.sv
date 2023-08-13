
`timescale 1ns/1ps
`default_nettype none

module vector_multiplier
    #(
        parameter VECTOR_LENGTH = 16,
        parameter FIXED_POINT_LENGTH = 16,
        parameter FIXED_POINT_POSITION = 10
    )
    (
        input wire clk_in,
        input wire [VECTOR_LENGTH*FIXED_POINT_LENGTH-1:0] vector_1_in,
        input wire [VECTOR_LENGTH*FIXED_POINT_LENGTH-1:0] vector_2_in,
        output logic [FIXED_POINT_LENGTH-1:0] product_out
    );

    localparam UNRECTIFIED_DATA_WIDTH = FIXED_POINT_LENGTH * 2;

// -----------------------------Define In/Outs---------------------------------
    
    // Inputs
    logic [VECTOR_LENGTH*FIXED_POINT_LENGTH-1:0] vector_1_in_d, vector_1_in_q;
    logic [VECTOR_LENGTH*FIXED_POINT_LENGTH-1:0] vector_2_in_d, vector_2_in_q;

    // Outputs
    logic [FIXED_POINT_LENGTH-1:0] product_out_d, product_out_q;

// -----------------------------Assign In/Outs---------------------------------
    
    always_comb begin : ASSIGN_INPUT_SIGNALS
        vector_1_in_d = vector_1_in;
        vector_2_in_d = vector_2_in;
    end

    always_comb begin : ASSIGN_OUTPUT_SIGNALS
        product_out = product_out_q;
    end

// -----------------------------Define Signals---------------------------------
    logic [VECTOR_LENGTH*UNRECTIFIED_DATA_WIDTH-1:0] product_d, product_q;

// -----------------------------Assign Signals---------------------------------

    generate
        for (genvar i = 0; i < VECTOR_LENGTH; i = i + 1) begin : multipliers_loop
            signed_fixed_point_multiplier #(
                .FIXED_POINT_LENGTH(FIXED_POINT_LENGTH),
                .FIXED_POINT_POSITION(FIXED_POINT_POSITION)
            ) FIXED_POINT_MULTIPLIER_1 (
                .clk_in(clk_in),
                .multiplicand_in(vector_1_in_q[VECTOR_LENGTH*FIXED_POINT_LENGTH +: FIXED_POINT_LENGTH]),
                .multiplier_in(vector_2_in_q[VECTOR_LENGTH*FIXED_POINT_LENGTH +: FIXED_POINT_LENGTH]),
                .product_out(product_d[VECTOR_LENGTH*UNRECTIFIED_DATA_WIDTH +: UNRECTIFIED_DATA_WIDTH])
            );
        end
    endgenerate


// ----------------------------Register Signals--------------------------------

    always_ff @(posedge clk_in) begin: REGISTER_INPUT_SIGNALS
        vector_1_in_q <= vector_1_in_d;
        vector_2_in_q <= vector_2_in_d;
    end

    always_ff @(posedge clk_in) begin: REGISTER_OUTPUT_SIGNALS
        product_out_q <= product_out_d;
    end

    always_ff @(posedge clk_in) begin: REGISTER_DESIGN_SIGNALS
        product_q <= product_d;
    end

endmodule
