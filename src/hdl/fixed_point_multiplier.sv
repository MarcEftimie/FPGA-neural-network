
`timescale 1ns/1ps
`default_nettype none

module fixed_point_multiplier
    #(
        parameter FIXED_POINT_LENGTH = 16,
        parameter FIXED_POINT_POSITION = 10
    )
    (
        input wire clk_in,
        input wire [FIXED_POINT_LENGTH-1:0] fixed_point_1_in,
        input wire [FIXED_POINT_LENGTH-1:0] fixed_point_2_in,
        output logic [FIXED_POINT_LENGTH-1:0] product_out
    );

// -----------------------------Define In/Outs---------------------------------
    
    // Inputs
    logic [FIXED_POINT_LENGTH-1:0] fixed_point_1_in_d, fixed_point_1_in_q;
    logic [FIXED_POINT_LENGTH-1:0] fixed_point_2_in_d, fixed_point_2_in_q;

    // Outputs
    logic [FIXED_POINT_LENGTH-1:0] product_out_d, product_out_q;

// -----------------------------Assign In/Outs---------------------------------
    
    always_comb begin : ASSIGN_INPUT_SIGNALS
        fixed_point_1_in_d = fixed_point_1_in;
        fixed_point_2_in_d = fixed_point_2_in;
    end

    always_comb begin : ASSIGN_OUTPUT_SIGNALS
        product_out = product_out_q;
    end

// -----------------------------Define Signals---------------------------------
    logic [(FIXED_POINT_LENGTH*2)-1:0] unrectified_product_d, unrectified_product_q;

// -----------------------------Assign Signals---------------------------------


    multiplier #(
        .FACTOR_WIDTH(FIXED_POINT_LENGTH),
        .FIXED_POINT_POSITION(FIXED_POINT_POSITION)
    ) MULTIPLIER (
        .clk_in(clk_in),
        .multiplicand_in(fixed_point_1_in_q),
        .multiplier_in(fixed_point_2_in_q),
        .product_out(unrectified_product_d)
    );

    overflow_underflow_rectifier #(
        .UNRECTIFIED_DATA_WIDTH(FIXED_POINT_LENGTH*2),
        .RECTIFIED_DATA_WIDTH(FIXED_POINT_LENGTH)
    ) OVERFLOW_UNDERFLOW_RECTIFIER (
        .clk_in(clk_in),
        .unrectified_data_in(unrectified_product_q),
        .rectified_data_out(product_out_d)
    );

// ----------------------------Register Signals--------------------------------

    always_ff @(posedge clk_in) begin: REGISTER_INPUT_SIGNALS
        fixed_point_1_in_q <= fixed_point_1_in_d;
        fixed_point_2_in_q <= fixed_point_2_in_d;
    end

    always_ff @(posedge clk_in) begin: REGISTER_OUTPUT_SIGNALS
        product_out_q <= product_out_d;
    end

    always_ff @(posedge clk_in) begin: REGISTER_DESIGN_SIGNALS
        unrectified_product_q <= unrectified_product_d;
    end

endmodule
