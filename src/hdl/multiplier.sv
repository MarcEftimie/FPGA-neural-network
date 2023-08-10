
`timescale 1ns/1ps
`default_nettype none

module multiplier
    #(
        parameter FACTOR_WIDTH = 16,
        parameter FIXED_POINT_POSITION = 10,
        parameter PRODUCT_WIDTH = FACTOR_WIDTH * 2
    )
    (
        input wire clk_in,
        input wire [FACTOR_WIDTH-1:0] multiplicand_in,
        input wire [FACTOR_WIDTH-1:0] multiplier_in,
        output logic [PRODUCT_WIDTH-1:0] product_out
    );
    
// -----------------------------Define In/Outs---------------------------------
    
    // Inputs
    logic [FACTOR_WIDTH-1:0] multiplicand_in_d, multiplicand_in_q;
    logic [FACTOR_WIDTH-1:0] multiplier_in_d, multiplier_in_q;

    // Outputs
    logic [PRODUCT_WIDTH-1:0] product_out_d, product_out_q;

// -----------------------------Assign In/Outs---------------------------------
    
    always_comb begin : ASSIGN_INPUT_SIGNALS
        multiplicand_in_d = multiplicand_in;
        multiplier_in_d = multiplier_in;
    end

    always_comb begin : ASSIGN_OUTPUT_SIGNALS
        product_out = product_out_q;
    end

// -----------------------------Define Signals---------------------------------
    logic [PRODUCT_WIDTH-1:0] product_d, product_q;

// -----------------------------Assign Signals---------------------------------

    always_comb begin : BLOCK_LOGIC
        product_d = $signed(multiplicand_in_q) * $signed(multiplier_in_q);
        product_out_d = $signed(product_q) >>> FIXED_POINT_POSITION;
    end

// ----------------------------Register Signals--------------------------------

    always_ff @(posedge clk_in) begin: REGISTER_INPUT_SIGNALS
        multiplicand_in_q <= multiplicand_in_d;
        multiplier_in_q <= multiplier_in_d;
    end

    always_ff @(posedge clk_in) begin: REGISTER_OUTPUT_SIGNALS
        product_out_q <= product_out_d;
    end

    always_ff @(posedge clk_in) begin: REGISTER_DESIGN_SIGNALS
        product_q <= product_d;
    end

endmodule
