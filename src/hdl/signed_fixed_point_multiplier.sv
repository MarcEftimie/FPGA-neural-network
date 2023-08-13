
`timescale 1ns/1ps
`default_nettype none

module signed_fixed_point_multiplier
    #(
        parameter FIXED_POINT_LENGTH = 16,
        parameter FIXED_POINT_POSITION = 10
    )
    (
        input wire clk_in,
        input wire signed [FIXED_POINT_LENGTH-1:0] multiplicand_in,
        input wire signed [FIXED_POINT_LENGTH-1:0] multiplier_in,
        output logic signed [FIXED_POINT_LENGTH-1:0] product_out
    );

// -----------------------------Define In/Outs---------------------------------
    
    // Inputs
    logic signed [FIXED_POINT_LENGTH-1:0] multiplicand_in_d, multiplicand_in_q;
    logic signed [FIXED_POINT_LENGTH-1:0] multiplier_in_d, multiplier_in_q;

    // Outputs
    logic signed [FIXED_POINT_LENGTH-1:0] product_out_d, product_out_q;

// -----------------------------Assign In/Outs---------------------------------
    
    always_comb begin : ASSIGN_INPUT_SIGNALS
        multiplicand_in_d = multiplicand_in;
        multiplier_in_d = multiplier_in;
    end

    always_comb begin : ASSIGN_OUTPUT_SIGNALS
        product_out = product_out_q;
    end

// -----------------------------Define Signals---------------------------------
    logic signed [(FIXED_POINT_LENGTH*2)-1:0] unrectified_product_d, unrectified_product_q;
    logic signed [(FIXED_POINT_LENGTH*2)-1:0] shifted_unrectified_product_d, shifted_unrectified_product_q;

// -----------------------------Assign Signals---------------------------------


    always_comb begin : MULTIPLIER
        unrectified_product_d = multiplicand_in_q * multiplier_in_q;
    end

    always_comb begin : PRODUCT_SHIFTING_TO_FIXED_POINT
        shifted_unrectified_product_d = unrectified_product_q >>> 10;
    end

    overflow_underflow_rectifier #(
        .UNRECTIFIED_DATA_WIDTH(FIXED_POINT_LENGTH*2),
        .RECTIFIED_DATA_WIDTH(FIXED_POINT_LENGTH)
    ) OVERFLOW_UNDERFLOW_RECTIFIER (
        .clk_in(clk_in),
        .unrectified_num_in(shifted_unrectified_product_q),
        .rectified_num_out(product_out_d)
    );

// ----------------------------Register Signals--------------------------------

    always_ff @(posedge clk_in) begin: REGISTER_INPUT_SIGNALS
        multiplicand_in_q <= multiplicand_in_d;
        multiplier_in_q <= multiplier_in_d;
    end

    always_ff @(posedge clk_in) begin: REGISTER_OUTPUT_SIGNALS
        product_out_q <= product_out_d;
    end

    always_ff @(posedge clk_in) begin: REGISTER_DESIGN_SIGNALS
        unrectified_product_q <= unrectified_product_d;
        shifted_unrectified_product_q <= shifted_unrectified_product_d;
    end

endmodule
