
`timescale 1ns/1ps
`default_nettype none

module overflow_underflow_rectifier
    #(
        parameter UNRECTIFIED_DATA_WIDTH = 32,
        parameter RECTIFIED_DATA_WIDTH = 16
    )
    (
        input wire clk_in,
        input wire [UNRECTIFIED_DATA_WIDTH-1:0] unrectified_data_in,
        output logic [RECTIFIED_DATA_WIDTH-1:0] rectified_data_out
    );

    localparam MAX_VALUE = (2**(RECTIFIED_DATA_WIDTH-1)) - 1;
    localparam MIN_VALUE = -(2**(RECTIFIED_DATA_WIDTH-1));
// -----------------------------Define In/Outs---------------------------------
    
    // Inputs
    logic [UNRECTIFIED_DATA_WIDTH-1:0] unrectified_data_in_d, unrectified_data_in_q;

    // Outputs
    logic [RECTIFIED_DATA_WIDTH-1:0] rectified_data_out_d, rectified_data_out_q;

// -----------------------------Assign In/Outs---------------------------------
    
    always_comb begin : ASSIGN_INPUT_SIGNALS
        unrectified_data_in_d = unrectified_data_in;
    end

    always_comb begin : ASSIGN_OUTPUT_SIGNALS
        rectified_data_out = rectified_data_out_q;
    end

// -----------------------------Define Signals---------------------------------
    logic overflow;
    logic underflow;

// -----------------------------Assign Signals---------------------------------

    always_comb begin : OVERFLOW_UNDERFLOW_DETECTION
        overflow = $signed(unrectified_data_in_q) > MAX_VALUE;
        underflow = $signed(unrectified_data_in_q) < MIN_VALUE;
    end

    always_comb begin : RECTIFICATION
        if (overflow) begin
            rectified_data_out_d = MAX_VALUE;
        end else if (underflow) begin
            rectified_data_out_d = MIN_VALUE;
        end else begin
            rectified_data_out_d = unrectified_data_in_q[RECTIFIED_DATA_WIDTH-1:0];
        end
    end

// ----------------------------Register Signals--------------------------------

    always_ff @(posedge clk_in) begin: REGISTER_INPUT_SIGNALS
        unrectified_data_in_q <= unrectified_data_in_d;
    end

    always_ff @(posedge clk_in) begin: REGISTER_OUTPUT_SIGNALS
        rectified_data_out_q <= rectified_data_out_d;
    end

    always_ff @(posedge clk_in) begin: REGISTER_DESIGN_SIGNALS
    end

endmodule
