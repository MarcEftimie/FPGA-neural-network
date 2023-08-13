
`timescale 1ns/1ps
`default_nettype none

module overflow_underflow_rectifier
    #(
        parameter UNRECTIFIED_DATA_WIDTH = 32,
        parameter RECTIFIED_DATA_WIDTH = 16
    )
    (
        input wire clk_in,
        input wire signed [UNRECTIFIED_DATA_WIDTH-1:0] unrectified_num_in,
        output logic signed [RECTIFIED_DATA_WIDTH-1:0] rectified_num_out
    );

    localparam MAX_VALUE = (2**(RECTIFIED_DATA_WIDTH-1)) - 1;
    localparam MIN_VALUE = -(2**(RECTIFIED_DATA_WIDTH-1));
// -----------------------------Define In/Outs---------------------------------
    
    // Inputs
    logic signed [UNRECTIFIED_DATA_WIDTH-1:0] unrectified_num_in_d, unrectified_num_in_q;

    // Outputs
    logic signed [RECTIFIED_DATA_WIDTH-1:0] rectified_num_out_d, rectified_num_out_q;

// -----------------------------Assign In/Outs---------------------------------
    
    always_comb begin : ASSIGN_INPUT_SIGNALS
        unrectified_num_in_d = unrectified_num_in;
    end

    always_comb begin : ASSIGN_OUTPUT_SIGNALS
        rectified_num_out = rectified_num_out_q;
    end

// -----------------------------Define Signals---------------------------------
    logic unrectified_num_has_overflow;
    logic unrectified_num_has_underflow;

// -----------------------------Assign Signals---------------------------------

    always_comb begin : OVERFLOW_UNDERFLOW_DETECTION
        unrectified_num_has_overflow = unrectified_num_in_q > MAX_VALUE;
        unrectified_num_has_underflow = unrectified_num_in_q < MIN_VALUE;
    end

    always_comb begin : RECTIFICATION
        if (unrectified_num_has_overflow) begin
            rectified_num_out_d = MAX_VALUE;
        end else if (unrectified_num_has_underflow) begin
            rectified_num_out_d = MIN_VALUE;
        end else begin
            rectified_num_out_d = unrectified_num_in_q[RECTIFIED_DATA_WIDTH-1:0];
        end
    end

// ----------------------------Register Signals--------------------------------

    always_ff @(posedge clk_in) begin: REGISTER_INPUT_SIGNALS
        unrectified_num_in_q <= unrectified_num_in_d;
    end

    always_ff @(posedge clk_in) begin: REGISTER_OUTPUT_SIGNALS
        rectified_num_out_q <= rectified_num_out_d;
    end

    always_ff @(posedge clk_in) begin: REGISTER_DESIGN_SIGNALS
    end

endmodule
