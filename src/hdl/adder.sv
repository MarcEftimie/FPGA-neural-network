
`timescale 1ns/1ps
`default_nettype none

module adder
    #(
        parameter ADDEND_WIDTH = 16,
        parameter SUM_WIDTH = ADDEND_WIDTH + 1
    )
    (
        input wire clk_in,
        input wire [ADDEND_WIDTH-1:0] addend_1_in,
        input wire [ADDEND_WIDTH-1:0] addend_2_in,
        output logic [SUM_WIDTH-1:0] sum_out
    );

// -----------------------------Define In/Outs---------------------------------
    
    // Inputs
    logic [ADDEND_WIDTH-1:0] addend_1_in_d, addend_1_in_q;
    logic [ADDEND_WIDTH-1:0] addend_2_in_d, addend_2_in_q;

    // Outputs
    logic [SUM_WIDTH-1:0] sum_out_d, sum_out_q;

// -----------------------------Assign In/Outs---------------------------------
    
    always_comb begin : ASSIGN_INPUT_SIGNALS
        addend_1_in_d = addend_1_in;
        addend_2_in_d = addend_2_in;
    end

    always_comb begin : ASSIGN_OUTPUT_SIGNALS
        sum_out = sum_out_q;
    end

// -----------------------------Define Signals---------------------------------

// -----------------------------Assign Signals---------------------------------

    always_comb begin : BLOCK_LOGIC
        sum_out_d = $signed(addend_1_in_q) + $signed(addend_2_in_q); 
    end

// ----------------------------Register Signals--------------------------------

    always_ff @(posedge clk_in) begin: REGISTER_INPUT_SIGNALS
        addend_1_in_q <= addend_1_in_d;
        addend_2_in_q <= addend_2_in_d;
    end

    always_ff @(posedge clk_in) begin: REGISTER_OUTPUT_SIGNALS
        sum_out_q <= sum_out_d;
    end

    always_ff @(posedge clk_in) begin: REGISTER_DESIGN_SIGNALS
    end

endmodule
