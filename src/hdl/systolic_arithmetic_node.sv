
`timescale 1ns/1ps
`default_nettype none

module systolic_arithmetic_node
    #(
        parameter FIXED_POINT_WIDTH = 16,
        parameter PARTIAL_SUM_WIDTH_IN = 16,
        parameter PARTIAL_SUM_WIDTH_OUT = PARTIAL_SUM_WIDTH_IN + 1,
        parameter FIXED_POINT_POSITION = 10
    )
    (
        input wire clk_in,
        input wire weight_valid_in,
        input wire signed [FIXED_POINT_WIDTH-1:0] weight_in,
        input wire signed [FIXED_POINT_WIDTH-1:0] activation_in,
        input wire signed [PARTIAL_SUM_WIDTH_IN-1:0] partial_sum_in,
        output logic signed [FIXED_POINT_WIDTH-1:0] activation_out,
        output logic signed [PARTIAL_SUM_WIDTH_OUT-1:0] partial_sum_out
    );

    localparam UNRECTIFIED_PRODUCT_WIDTH = 2 * FIXED_POINT_WIDTH;

// -------------------------Define In/Out Registers----------------------------
    
    // Inputs
    logic signed [FIXED_POINT_WIDTH-1:0] activation_in_d, activation_in_q;
    logic signed [PARTIAL_SUM_WIDTH_IN-1:0] partial_sum_in_d, partial_sum_in_q;

// -------------------------Assign In/Out Registers----------------------------
    
    always_comb begin : ASSIGN_INPUT_SIGNALS
        activation_in_d = activation_in;
        partial_sum_in_d = partial_sum_in;
    end

// -----------------------------Define Signals---------------------------------
    logic signed [FIXED_POINT_WIDTH-1:0] weight_d, weight_q;

    logic signed [FIXED_POINT_WIDTH-1:0] activation_delay_d, activation_delay_q;

    logic signed [PARTIAL_SUM_WIDTH_IN-1:0] partial_sum_delay_d, partial_sum_delay_q;

    logic weight_activation_signs_dont_match_d, weight_activation_signs_dont_match_q;

    logic signed [UNRECTIFIED_PRODUCT_WIDTH-1:0] unrectified_product_d, unrectified_product_q;
    logic signed [FIXED_POINT_WIDTH-1:0] rectified_product;

    logic product_overflow_detected;
    logic product_underflow_detected;

// -----------------------------Assign Signals---------------------------------

    always_comb begin : LOAD_WEIGHT
        if (weight_valid_in) begin
            weight_d = weight_in;
        end else begin
            weight_d = weight_q;
        end
    end

    always_comb begin : PARTIAL_SUM_IN_DELAY
        partial_sum_delay_d = partial_sum_in_q;
    end

    always_comb begin : ACTIVATION_IN_DELAY
        activation_delay_d = activation_in_q;
    end

    always_comb begin : WEIGHT_ACTIVATION_SIGNS_DONT_MATCH
        weight_activation_signs_dont_match_d = weight_q[FIXED_POINT_WIDTH-1] ^ activation_in_q[FIXED_POINT_WIDTH-1];
    end

    always_comb begin : WEIGHT_ACTIVATION_MULTIPLICATION
        unrectified_product_d = weight_q * activation_in_q;
    end

    always_comb begin : OVER_AND_UNDERFLOW_PRODUCT_DETECTION
        product_overflow_detected = $signed(unrectified_product_q[UNRECTIFIED_PRODUCT_WIDTH-1: FIXED_POINT_POSITION]) > 32767;
        product_underflow_detected = $signed(unrectified_product_q[UNRECTIFIED_PRODUCT_WIDTH-1: FIXED_POINT_POSITION]) < -32768;
    end

    always_comb begin : PRODUCT_RECTIFICATION
        if (product_overflow_detected) begin
            rectified_product = {1'b0, {(FIXED_POINT_WIDTH-1){1'b1}}};
        end else if (product_underflow_detected) begin
            rectified_product = {1'b1, {(FIXED_POINT_WIDTH-1){1'b0}}};
        end else begin
            rectified_product = unrectified_product_q[UNRECTIFIED_PRODUCT_WIDTH - (FIXED_POINT_WIDTH-FIXED_POINT_POSITION) - 1 : FIXED_POINT_POSITION];
        end
    end

    always_comb begin : PARTIAL_SUM_PRODUCT_ADDITION
        partial_sum_out = rectified_product + partial_sum_in_q;
    end

    always_comb begin : PASS_ACTIVATION_TO_RIGHT_NODE
        activation_out = activation_delay_q;
    end
// ----------------------------Register Signals--------------------------------

    always_ff @(posedge clk_in) begin : REGISTER_INPUT_SIGNALS
        activation_in_q <= activation_in_d;
        partial_sum_in_q <= partial_sum_in_d;
    end

    always_ff @(posedge clk_in) begin : REGISTER_DESIGN_SIGNALS
        weight_q <= weight_d;
        partial_sum_delay_q <= partial_sum_delay_d;
        unrectified_product_q <= unrectified_product_d;
        weight_activation_signs_dont_match_q <= weight_activation_signs_dont_match_d;
        activation_delay_q <= activation_delay_d;
    end

endmodule
