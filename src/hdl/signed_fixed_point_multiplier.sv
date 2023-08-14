
`timescale 1ns/1ps
`default_nettype none

module signed_fixed_point_multiplier
    #(
        parameter FIXED_POINT_WIDTH = 16,
        parameter FIXED_POINT_POSITION = 10,
        parameter FINAL_PRODUCT_WIDTH = FIXED_POINT_WIDTH
    )
    (
        input wire clk_in,
        input wire signed [FIXED_POINT_WIDTH-1:0] multiplicand_in,
        input wire signed [FIXED_POINT_WIDTH-1:0] multiplier_in,
        output logic signed [FINAL_PRODUCT_WIDTH-1:0] product_out
    );

    localparam UNRECTIFIED_PRODUCT_WIDTH = FIXED_POINT_WIDTH * 2;

// -----------------------------Define Signals---------------------------------
    logic signed [UNRECTIFIED_PRODUCT_WIDTH-1:0] unrectified_product_d, unrectified_product_q;
    logic signed [UNRECTIFIED_PRODUCT_WIDTH-1:0] shifted_unrectified_product;
    logic signed [FIXED_POINT_WIDTH-1:0] rectified_product;

// -----------------------------Assign Signals---------------------------------


    always_comb begin : MULTIPLIER
        unrectified_product_d = multiplicand_in * multiplier_in;
    end

    always_comb begin : PRODUCT_SHIFTING_TO_FIXED_POINT
        shifted_unrectified_product = unrectified_product_q >>> FIXED_POINT_POSITION;
    end

    overflow_underflow_rectifier #(
        .UNRECTIFIED_DATA_WIDTH(FIXED_POINT_WIDTH*2),
        .RECTIFIED_DATA_WIDTH(FIXED_POINT_WIDTH)
    ) OVERFLOW_UNDERFLOW_RECTIFIER (
        .clk_in(clk_in),
        .unrectified_num_in(shifted_unrectified_product),
        .rectified_num_out(product_out)
    );

// ----------------------------Register Signals--------------------------------

    always_ff @(posedge clk_in) begin: REGISTER_DESIGN_SIGNALS
        unrectified_product_q <= unrectified_product_d;
    end

endmodule
